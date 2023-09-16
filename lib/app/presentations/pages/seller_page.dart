import 'package:cached_network_image/cached_network_image.dart';
import 'package:emarket_buyer/app/common/formatter.dart';
import 'package:emarket_buyer/app/models/model.dart';
import 'package:emarket_buyer/app/presentations/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class SellerPage extends StatefulWidget {
  const SellerPage({Key? key, required this.seller}) : super(key: key);

  final SellerModel seller;

  @override
  State<SellerPage> createState() => _SellerPageState();
}

class _SellerPageState extends State<SellerPage> with TickerProviderStateMixin {
  late TabController _tabController;
  GoogleMapController? _controller;

  final ProductController productController = Get.find<ProductController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toko'),
      ),
      body: Column(
        children: [
          buildSellerInfo(),
          const SizedBox(height: 10),
          Container(
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.black12,
            ),
            child: TabBar(
              controller: _tabController,
              splashFactory: NoSplash.splashFactory,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: const Color.fromARGB(255, 68, 151, 76),
                borderRadius: BorderRadius.circular(16),
              ),
              labelColor: Colors.white,
              tabs: const [
                Text('Info Toko'),
                Text('Produk'),
              ],
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: TabBarView(
              controller: _tabController,
              children: [
                buildStoreInfo(),
                buildProductList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildStoreInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 14,
      ),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black12,
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.store,
                      size: 70,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.seller.storeName,
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          widget.seller.phoneNumber,
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          widget.seller.address,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: GoogleMap(
                    zoomControlsEnabled: false,
                    zoomGesturesEnabled: false,
                    mapToolbarEnabled: false,
                    onMapCreated: (controller) {
                      setState(() {
                        _controller = controller;
                      });
                    },
                    minMaxZoomPreference: const MinMaxZoomPreference(1, 20),
                    rotateGesturesEnabled: false,
                    scrollGesturesEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        widget.seller.location.latitude,
                        widget.seller.location.longitude,
                      ),
                      zoom: 16.7,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('seller'),
                        position: LatLng(
                          widget.seller.location.latitude,
                          widget.seller.location.longitude,
                        ),
                      ),
                    },
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 5,
            right: 5,
            child: IconButton.filled(
              onPressed: () {
                MapsLauncher.launchCoordinates(
                  widget.seller.location.latitude,
                  widget.seller.location.longitude,
                );
              },
              icon: const Icon(
                Icons.map,
              ),
            ),
          )
        ],
      ),
    );
  }

  buildSellerInfo() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black12,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              widget.seller.photoUrl,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.seller.displayName,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              Text(
                widget.seller.email,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  buildProductList() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black12,
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: productController.product.length,
        itemBuilder: (context, index) {
          final product = productController.product[index];
          if (product.sellerId == widget.seller.id) {
            return Card(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      width: 80,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Text(Formatter.priceFormat(product.price)),
                    ],
                  )
                ],
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}

class MapUtils {
  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    String mapUrl =
        'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(mapUrl))) {
      await launchUrl(Uri.parse(mapUrl));
    } else {
      throw 'Could not open the map.';
    }
  }
}
