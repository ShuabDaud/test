import 'package:flutter/material.dart';
import 'package:shop_app/models/gas_provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class GasLeakage extends StatelessWidget {
  late final double gasLeakage;

  GasLeakage({
    required this.gasLeakage,
  });

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(axes: <RadialAxis>[
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
        radiusFactor: 0.87,
        majorTickStyle: MajorTickStyle(
            length: 0.1, thickness: 2, lengthUnit: GaugeSizeUnit.factor),
        minorTickStyle: MinorTickStyle(
            length: 0.05, thickness: 1.5, lengthUnit: GaugeSizeUnit.factor),
        minimum: 0,
        maximum: 100,
        interval: 10,
        startAngle: 140,
        endAngle: 40,
        ranges: <GaugeRange>[
          GaugeRange(
            startValue: 0,
            endValue: 100,
            startWidth: 0.08,
            sizeUnit: GaugeSizeUnit.factor,
            endWidth: 0.08,
            gradient: SweepGradient(
              stops: <double>[0.2, 0.5, 0.75],
              colors: <Color>[Colors.green, Colors.yellow, Colors.red],
            ),
          ),
        ],
        pointers: <GaugePointer>[
          NeedlePointer(
              value: gasLeakage,  // points if there is a leak...
              needleColor: Colors.purple,
              tailStyle: TailStyle(
                  length: 0.18,
                  width: 8,
                  color: Colors.purple,
                  lengthUnit: GaugeSizeUnit.factor),
              needleLength: .60,
              needleStartWidth: .7,
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
                'LEAKAGE',
                style: TextStyle(
                    color: Colors.purple,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 5),
              ),
              positionFactor: .7,
              angle: 90)
        ],
      ),
    ]);
  }
}
