import 'package:flutter/material.dart';
import 'package:wm_com/src/models/menu_item.dart';

class MenuItems {
  static const List<MenuItemModel> itemsFirst = [
    itemProfile,
    itemAnnuaire,
    itemHelp,
    itemSettings,
  ];

  static const List<MenuItemModel> itemsSecond = [
    itemLogout,
  ];

  static const itemProfile = MenuItemModel(
    text: 'Profil',
    icon: Icons.person,
  );
  static const itemAnnuaire = MenuItemModel(
    text: 'Annuaire',
    icon: Icons.contact_phone,
  );
  static const itemHelp = MenuItemModel(
    text: 'Aide',
    icon: Icons.help,
  );
  static const itemSettings = MenuItemModel(
    text: 'Settings',
    icon: Icons.settings,
  );

  static const itemLogout =
      MenuItemModel(text: 'Déconnexion', icon: Icons.logout);
}
