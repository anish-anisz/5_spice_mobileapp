import 'package:flutter/material.dart';

import '../../models/order_model.dart';


extension OrderStatusExtension on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.all:
        return 'All';
      case OrderStatus.newOrder:
        return 'New Order';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.ready:
        return 'Ready';
      case OrderStatus.closed:
        return 'Closed';
      case OrderStatus.delay:
        return 'Delayed';
      // case OrderStatus.queue:
      //   return 'Queued';
    }
  }
}

