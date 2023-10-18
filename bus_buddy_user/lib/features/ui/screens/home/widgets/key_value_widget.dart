import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KeyValueWidget extends StatelessWidget {
  final String title;
  final String? value;
  final TextAlign? textAlign;
  final double? iconSize;
  final IconData? iconData;
  final Color? iconColor;
  final Widget? tooltipIcon;
  final Function()? onValueClicked;
  final CrossAxisAlignment? crossAxisAlignment;
  const KeyValueWidget(
      {Key? key,
      required this.title,
      required this.value,
      this.textAlign,
      this.iconData,
      this.iconSize,
      this.iconColor,
      this.tooltipIcon,
      this.onValueClicked,
      this.crossAxisAlignment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.lato().copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        onValueClicked != null
            ? InkWell(
                onTap: () {
                  onValueClicked!();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment:
                      crossAxisAlignment == CrossAxisAlignment.end
                          ? MainAxisAlignment.end
                          : crossAxisAlignment == CrossAxisAlignment.center
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.start,
                  children: [
                    iconData != null
                        ? Icon(
                            iconData,
                            color: iconColor ?? Colors.black54,
                            size: iconSize,
                          )
                        : const SizedBox(),
                    iconData != null
                        ? const SizedBox(
                            width: 5.0,
                          )
                        : const SizedBox(),
                    Flexible(
                      child: Text(
                        value ?? "N/A",
                        maxLines: 3,
                        overflow: TextOverflow.fade,
                        textAlign: textAlign,
                      ),
                    ),
                  ],
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: crossAxisAlignment == CrossAxisAlignment.end
                    ? MainAxisAlignment.end
                    : crossAxisAlignment == CrossAxisAlignment.center
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                children: [
                  iconData != null
                      ? Icon(
                          iconData,
                          color: iconColor ?? Colors.black54,
                          size: iconSize,
                        )
                      : const SizedBox(),
                  iconData != null
                      ? const SizedBox(
                          width: 5.0,
                        )
                      : const SizedBox(),
                  Flexible(
                    child: Text(
                      value ?? "N/A",
                      maxLines: 3,
                      overflow: TextOverflow.fade,
                      textAlign: textAlign,
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}
