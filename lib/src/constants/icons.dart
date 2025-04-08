import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EvoIcon {
  final IconData icon;
  final Color? color; // Make color nullable with '?'

  const EvoIcon(
      {required this.icon, this.color}); // Remove 'required' from color
}

class EvoIcons {
  // Private constructor to prevent instantiation
  EvoIcons._();

  // Define icons with their properties
  static const EvoIcon tithes = EvoIcon(
    icon: FontAwesomeIcons.handHoldingHeart
  );

  static const EvoIcon donation = EvoIcon(
    icon: Icons.favorite,
  );

  static const EvoIcon offering = EvoIcon(
    icon: Icons.handshake,
  );

  
}
