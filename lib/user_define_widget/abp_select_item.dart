import 'package:flutter/material.dart';

List<String> timeRatioList = ["<25", "25-50", "51-75", ">75"];

class AbpSelectItem extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final String contentText;
  final String exampleText;
  final String image;
  final bool help;
  final IconButton? icon;
  final Function(String, bool) onTimeRatioChanged;

  const AbpSelectItem({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.contentText,
    required this.exampleText,
    required this.image,
    required this.help,
    this.icon,
    required this.onTimeRatioChanged,
  });

  @override
  State<AbpSelectItem> createState() => _AbpSelectItemState();
}

Widget circle(
  double radius,
  Color color,
) {
  return Container(
    width: radius,
    height: radius,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
    ),
  );
}

class _AbpSelectItemState extends State<AbpSelectItem> {
  bool isSelected = false;
  String selectedTimeRatio = "<25";

  void update(String value, bool isSelected) {
    setState(() {
      selectedTimeRatio = value;
      widget.onTimeRatioChanged(value, isSelected);
    });
  }

  Widget additionalPointCard(
    double screenWidth,
    double screenHeight,
    bool isSelected,
    String titleText,
    String contentText,
    double imgWidth,
    double imgHeight,
    double imgOffsetTop,
    double imgOffsetLeft,
    String img,
  ) {
    return Container(
      width: screenWidth * 0.64,
      height: screenHeight * 0.16,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0XFF6F8FA8) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 1,
            spreadRadius: 1,
            color: const Color(0x10000000),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: screenHeight * 0.06,
            left: screenWidth * 0.45,
            child: circle(
              screenHeight * 0.124,
              const Color(0xFFECECEC),
            ),
          ),
          Positioned(
            top: screenHeight * 0.03,
            left: screenWidth * 0.04,
            child: Text(
              titleText,
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.085,
            left: screenWidth * 0.04,
            child: Text(
              contentText,
              style: TextStyle(
                fontSize: screenWidth * 0.032,
                color: const Color(0XFF424242),
              ),
            ),
          ),
          Positioned(
            top: imgOffsetTop + screenHeight * 0.035,
            left: imgOffsetLeft - screenWidth * 0.03,
            child: SizedBox(
              width: imgWidth,
              height: imgHeight - screenHeight * 0.02,
              child: Image.asset(img),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(width: 1, color: Colors.black),
            ),
          ),
          if (widget.help) ...[
            Positioned(
              top: 0,
              left: screenWidth * 0.52,
              child: widget.icon!,
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
          if (!isSelected) {
            selectedTimeRatio = "<25";
          }
          update(selectedTimeRatio, isSelected);
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: widget.screenHeight * 0.025),
              IconButton(
                icon:
                    isSelected
                        ? Image.asset(
                          "assets/images/🅥.png",
                          fit: BoxFit.contain,
                        )
                        : Image.asset(
                          "assets/images/○.png",
                          fit: BoxFit.contain,
                        ),
                iconSize: widget.screenWidth * 0.056,
                color: Colors.black,
                onPressed: () {
                  setState(() {
                    isSelected = !isSelected;
                    update(selectedTimeRatio, isSelected);
                  });
                },
              ),
              SizedBox(height: widget.screenHeight * 0.01),
              Container(
                width: widget.screenWidth * 0.23,
                height: widget.screenHeight * 0.035,
                alignment: Alignment.center,
                decoration:
                    isSelected
                        ? BoxDecoration(
                          color: const Color(0XFFE9E9E9),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x60000000),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0, 1),
                            ),
                          ],
                        )
                        : null,
                child:
                    isSelected
                        ? DropdownButton<String>(
                          value: selectedTimeRatio,
                          isExpanded: true,
                          icon: SizedBox(),
                          underline: SizedBox(),
                          borderRadius: BorderRadius.circular(10),
                          items:
                              [
                                "作業時間佔比",
                                ...timeRatioList,
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  enabled: value == "作業時間佔比" ? false : true,
                                  child: StatefulBuilder(
                                    builder: (context, setState) {
                                      return Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color:
                                              selectedTimeRatio == value
                                                  ? Colors.grey.shade300
                                                  : Colors.transparent,
                                          border:
                                              value == ">75"
                                                  ? null
                                                  : Border(
                                                    bottom: BorderSide(
                                                      color: Colors.black54,
                                                      width: 1,
                                                    ),
                                                  ),
                                        ),
                                        child: Text(
                                          "$value%",
                                          style: TextStyle(
                                            fontSize:
                                                widget.screenWidth * 0.036,
                                            fontWeight:
                                                value == "作業時間佔比"
                                                    ? FontWeight.normal
                                                    : FontWeight.w500,
                                            color:
                                                value == "作業時間佔比"
                                                    ? Colors.grey
                                                    : Colors.black,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                          selectedItemBuilder: (BuildContext context) {
                            return ["作業時間佔比", ...timeRatioList].map((
                              String value,
                            ) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "$selectedTimeRatio%",
                                    style: TextStyle(
                                      fontSize: widget.screenWidth * 0.036,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Icon(
                                    Icons.expand_more,
                                    size: widget.screenWidth * 0.06,
                                  ),
                                  SizedBox(width: widget.screenWidth * 0.01),
                                ],
                              );
                            }).toList();
                          },
                          onChanged: (value) {
                            update(value!, isSelected);
                          },
                        )
                        : null,
              ),
            ],
          ),
          SizedBox(width: widget.screenWidth * 0.02),
          additionalPointCard(
            widget.screenWidth,
            widget.screenHeight,
            isSelected,
            widget.contentText,
            widget.exampleText,
            widget.screenWidth * 0.35,
            widget.screenHeight * 0.13,
            widget.screenHeight * 0.013,
            widget.screenHeight * 0.18,
            widget.image,
          ),
        ],
      ),
    );
  }
}
