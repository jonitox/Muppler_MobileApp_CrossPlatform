import 'package:flutter/material.dart';

// ************ custom floatting button with outline ************ //
class CustomFloatingButton extends StatelessWidget {
  final String name;
  final IconData icon;
  final Function onPressed;
  final Color color;

  CustomFloatingButton(
      {this.name, this.icon, this.onPressed, this.color = Colors.deepOrange});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: deviceSize.width * 0.4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 1, color: color),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null)
                  Icon(
                    icon,
                    color: color,
                  ),
                Text(
                  name,
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: color),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
