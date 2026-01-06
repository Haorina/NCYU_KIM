import 'package:flutter/material.dart';

class SettingCard extends StatelessWidget {
  final dynamic icon;
  final bool trail;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const SettingCard({
    super.key,
    this.trail = true,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.02, vertical: screenWidth * 0.01),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          height: screenHeight * 0.12,
          decoration: BoxDecoration(
            color: const Color(0xF0F0F0F0),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              // 🔹 左側 icon 圓形底
              Container(
                width: screenWidth * 0.15,
                height: screenHeight * 0.15,
                margin: EdgeInsets.only(left: screenWidth * 0.04),
                child: Icon(icon, color: Colors.black87, size: screenWidth * 0.12),
              ),
              SizedBox(width: screenWidth * 0.04),
              // 🔹 中間標題與分數
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: screenWidth * 0.056,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      "$subtitle 分",
                      style: TextStyle(
                        fontSize: screenWidth * 0.056,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..shader = LinearGradient(
                            colors: [Colors.black45, Colors.black38],
                          ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                      ),
                    ),
                  ],
                ),
              ),
              // 🔹 右側箭頭
              if (trail)
                Container(
                  margin: EdgeInsets.only(right: screenWidth * 0.04),
                  decoration: BoxDecoration(
                    color: Colors.black12.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.black45,
                    size: screenWidth * 0.056,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
