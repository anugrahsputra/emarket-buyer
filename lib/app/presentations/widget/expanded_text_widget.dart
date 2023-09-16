import 'package:flutter/material.dart';

class ExpandedText extends StatefulWidget {
  final String text;
  const ExpandedText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  State<ExpandedText> createState() => _ExpandedTextState();
}

class _ExpandedTextState extends State<ExpandedText> {
  late String firstHalf;
  late String secondHalf;
  bool isExpanded = true;

  @override
  void initState() {
    super.initState();
    if (widget.text.length > 100) {
      firstHalf = widget.text.substring(0, 100);
      secondHalf = widget.text.substring(100, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty
          ? Text(widget.text)
          : Column(
              children: [
                Text(
                  isExpanded ? firstHalf : widget.text,
                ),
                const SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Row(
                    children: [
                      isExpanded
                          ? const Text(
                              "Tampilkan lebih banyak",
                              style: TextStyle(
                                color: Color(0xffa1cca5),
                              ),
                            )
                          : const Text(
                              "Tampilkan lebih sedikit",
                              style: TextStyle(
                                color: Color(0xffa1cca5),
                              ),
                            ),
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up,
                        color: const Color(0xffa1cca5),
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
