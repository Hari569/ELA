import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '/models/product.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'shortlist_channel',
      'Shortlist Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  Future<void> checkShortlistedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productsString = prefs.getString('shortlisted_products');
    if (productsString == null) return;

    List<Product> shortlistedProducts = Product.decode(productsString);
    bool updatesOccurred = false;

    for (var product in shortlistedProducts) {
      bool wasAvailable = product.isAvailable;
      bool hadOffer = product.hasOffer;

      // Simulating API calls to check product status
      product.isAvailable = await _checkProductAvailability(product);
      product.hasOffer = await _checkProductOffer(product);

      if (!wasAvailable && product.isAvailable) {
        await showNotification(
          'Product Available',
          '${product.name} is now available!',
        );
        updatesOccurred = true;
      }

      if (!hadOffer && product.hasOffer) {
        await showNotification(
          'New Offer',
          'New offer available for ${product.name}!',
        );
        updatesOccurred = true;
      }
    }

    // Save updated products if any changes occurred
    if (updatesOccurred) {
      await prefs.setString(
          'shortlisted_products', Product.encode(shortlistedProducts));
    }
  }

  Future<bool> _checkProductAvailability(Product product) async {
    // Implement actual API call to check product availability
    // For demonstration, we'll use a random boolean
    return DateTime.now().millisecondsSinceEpoch % 2 == 0;
  }

  Future<bool> _checkProductOffer(Product product) async {
    // Implement actual API call to check for new offers
    // For demonstration, we'll use a random boolean
    return DateTime.now().millisecondsSinceEpoch % 3 == 0;
  }
}
