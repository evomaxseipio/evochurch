
import 'package:evochurch/src/constants/constant_index.dart';
import 'package:evochurch/src/constants/icons.dart';
import 'package:evochurch/src/widgets/widget_index.dart';
import 'package:flutter/material.dart';

class EvoCard extends StatelessWidget {
  const EvoCard({
    super.key,
    this.child,
    this.height,
    this.width,
    this.colorLight,
    this.colorDark,
    this.image,
    this.padding,
  });

  final Widget? child;
  final double? height;
  final double? width;
  final Color? colorLight;
  final Color? colorDark;
  final DecorationImage? image;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding ?? const EdgeInsets.all(22.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [colorLight!, colorDark!]),
        image: image,
      ),
      child: child,
    );
  }
}

class DetailsCard extends StatelessWidget {
  const DetailsCard(
      {super.key,
      required this.title,
      required this.data,
      this.otherDetails,
      required this.image});

  final String title;
  final String data;
  final String? otherDetails;
  final String image;

  @override
  Widget build(BuildContext context) {
    return EvoCard(
      height: 190,
      // color: ConstColor.primary,
      image: DecorationImage(
        image: AssetImage(image),
        fit: BoxFit.contain,
        alignment: Alignment.centerRight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style:
                      EvoTheme.title(context).copyWith(color: Colors.white),
                ),
              ),
              EvoBox.w8,
              // const SvgIcon(
              //   icon: EvoIcons.menu,
              //   color: Colors.white,
              // ),
            ],
          ),
          Text(
            data,
            style: const TextStyle(
              fontSize: 36.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (otherDetails != null) ...[
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                otherDetails!,
                style: EvoTheme.text(context).copyWith(color: Colors.white),
              ),
            ),
          ]
        ],
      ),
    );
  }
}


class EvoWhiteCard extends StatelessWidget {
  const EvoWhiteCard({
    super.key,
    this.child,
    this.height,
    this.width,
    this.color,
    this.elevation,
    this.shadowColor,
  });

  final Widget? child;
  final double? height;
  final double? width;
  final Color? color;
  final double? elevation;
  final Color? shadowColor;


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation ?? 2,
      color: color ?? EvoColor.white,   
      shadowColor: shadowColor ?? EvoColor.blueLightChartColor,   
      child: child,
    );
  }
}
