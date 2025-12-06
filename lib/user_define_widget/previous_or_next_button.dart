import 'package:flutter/material.dart';

class PONButton extends StatelessWidget {
  const PONButton({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.havePrevious,
    required this.haveNextPage,
    required this.previousText,
    required this.nextText,
    this.previousPage,
    this.nextPage,
    this.onTap,
  });

  final double screenWidth;
  final double screenHeight;
  final bool havePrevious;
  final bool haveNextPage;
  final String previousText;
  final String nextText;
  final Widget? previousPage;
  final Widget? nextPage;
  final Future<void>? Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (havePrevious && previousPage != null) ...[
            SizedBox(
              width: screenWidth * 0.36,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => previousPage!),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.036,
                    vertical: screenHeight * 0.01,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: screenWidth * 0.054,
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Text(
                      previousText,
                      style: TextStyle(
                        fontSize: screenWidth * 0.039,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.12),
          ],
          if (haveNextPage && nextPage != null) ...[
            SizedBox(
              width: havePrevious ? screenWidth * 0.3 : screenWidth * 0.36,
              child: ElevatedButton(
                onPressed: () async {
                  if(onTap != null) {
                    await onTap!();
                  }

                  if(context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => nextPage!),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.036,
                    vertical: screenHeight * 0.01,
                  ), // 內邊距
                ),
                child: Row(
                  children: [
                    SizedBox(width: havePrevious ? screenWidth * 0.026 : screenWidth * 0.036),
                    Text(
                      nextText,
                      style: TextStyle(
                        fontSize: havePrevious ? screenWidth * 0.039 : screenWidth * 0.049,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: havePrevious ? screenWidth * 0.02 : screenWidth * 0.03),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: havePrevious ? screenWidth * 0.054 : screenWidth * 0.064,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
