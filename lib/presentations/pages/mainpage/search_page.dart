import 'package:emarket_buyer/presentations/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPage extends StatelessWidget {
  SearchPage({Key? key}) : super(key: key);
  final QueryController searchController = Get.find<QueryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari'),
      ),
      body: Column(
        children: [
          TextField(
            onChanged: (value) {
              searchController.searchProduct(value);
            },
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: searchController.searchResult.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      searchController.searchResult[index].name,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
