import 'package:flutter/material.dart';
import 'package:shop_app/models/gas_provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class GasLevel extends StatelessWidget {
  late final double gasLevel;

  GasLevel({
    required this.gasLevel,
  });

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(axes: <RadialAxis>[
      //  RadialAxis(
      // backgroundImage: const AssetImage('assets/images/dark_theme_gauge.png')),
      RadialAxis(
        ticksPosition: ElementsPosition.inside,
        labelsPosition: ElementsPosition.inside,
        minorTicksPerInterval: 10,
        axisLineStyle: AxisLineStyle(
          thicknessUnit: GaugeSizeUnit.factor,
          thickness: 0.1,
        ),
        axisLabelStyle:
            GaugeTextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        radiusFactor: 0.90,
        majorTickStyle: MajorTickStyle(
            length: 0.1, thickness: 2, lengthUnit: GaugeSizeUnit.factor),
        minorTickStyle: MinorTickStyle(
            length: 0.08, thickness: 3, lengthUnit: GaugeSizeUnit.factor),
        minimum: 0,
        maximum: 100,
        interval: 10,
        startAngle: 120,
        endAngle: 60,
        ranges: <GaugeRange>[
          GaugeRange(
            startValue: 0,
            endValue: 100,
            startWidth: 0.13,
            sizeUnit: GaugeSizeUnit.factor,
            endWidth: 0.13,
            gradient: SweepGradient(
              stops: <double>[0.10, 0.40, 0.65],
              colors: <Color>[Colors.red, Colors.yellow, Colors.green],
            ),
          ),
        ],
        pointers: <GaugePointer>[
          NeedlePointer(
              value: gasLevel, // points at the level of the cylinder...
              needleColor: Colors.purple,
              tailStyle: TailStyle(
                  length: 0.18,
                  width: 8,
                  color: Colors.purple,
                  lengthUnit: GaugeSizeUnit.factor),
              needleLength: 0.65,
              needleStartWidth: .08,
              needleEndWidth: 8,
              knobStyle: KnobStyle(
                  knobRadius: 0.07,
                  color: Colors.white,
                  borderWidth: 0.05,
                  borderColor: Colors.deepOrange),
              lengthUnit: GaugeSizeUnit.factor),
        ],
        annotations: <GaugeAnnotation>[
          GaugeAnnotation(
              widget: Text(
                'LEVEL',
                style: TextStyle(
                    color: Colors.purple,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 5),
              ),
              positionFactor: .9,
              angle: 90)
        ],
      ),
    ]);
  }
}
