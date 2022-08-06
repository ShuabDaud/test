import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/order_item.dart';

class OrderItemWidget extends StatefulWidget {
  // const OrderItemWidget({ Key? key }) : super(key: key);
  final OrderItem orderItem;

  OrderItemWidget(this.orderItem);

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            title: Text(
              '\$${widget.orderItem.amount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18),
            ),
            subtitle: Text(
              DateFormat('dd/mm/yy hh:mm').format(widget.orderItem.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
                size: 25,
              ),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
          if (_isExpanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.orderItem.products.length * 20.0 + 10, 100),
              child: ListView(
                children: widget.orderItem.products
                    .map((e) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${e.title}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '\$${e.price} X ${e.quantity}',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            )
                          ],
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
