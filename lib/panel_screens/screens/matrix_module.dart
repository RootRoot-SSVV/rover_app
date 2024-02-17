import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rover_app/providers/bt_controller.dart';
import 'package:rover_app/providers/modules/matrix_module_provider.dart';
import 'package:rover_app/providers/panels.dart';

import 'dart:developer' as dev;

class MatrixModulePanel extends StatelessWidget {
  const MatrixModulePanel({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<Panels>(context, listen: false).changeToModule(context, 2);

    return Center(child: Consumer<MatrixModuleProvider>(
      builder: (context, provider, child) {
        return AspectRatio(
          aspectRatio: 1.0,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 64,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8),
            itemBuilder: (BuildContext context, int index) {
              int row = index ~/ 8;
              int col = index % 8;

              return GestureDetector(
                onTap: () {
                  dev.log('$index');
                  provider.changeGridState(
                      Provider.of<BtController>(context, listen: false),
                      row,
                      col);
                },
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: provider.gridState[row][col]
                              ? Color(0xFFd2e4ff)
                              : Colors.transparent)),
                ),
              );
            },
          ),
        );
      },
    ));
  }
}
