
import 'package:evochurch/src/blocs/index_bloc.dart';
import 'package:evochurch/src/constants/constant_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcon extends StatelessWidget {
  final String icon;
  final Color? color;
  final double? size;
  const SvgIcon({super.key, required this.icon, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeModeBloc, ThemeModeState>(
      builder: (context, state) {
        return state.when(
          initial: () => const SizedBox.shrink(),
          success: (themeMode) => SvgPicture.asset(
            icon,
            color: _color(themeMode),
            width: size ?? 20,
            height: size ?? 20,
          ),
        );
      },
    );
  }

  Color? _color(bool themeMode) {
    if (color == null) return themeMode ? EvoColor.white : EvoColor.black;
    return color;
  }
}
