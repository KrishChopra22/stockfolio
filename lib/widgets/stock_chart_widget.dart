import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stockfolio/models/stock_chart_model.dart';

class StockChartWidget extends StatefulWidget {
  const StockChartWidget({required this.stockChartList, super.key});

  final List<StockChartModel> stockChartList;

  @override
  State<StockChartWidget> createState() => _StockChartWidgetState();
}

class _StockChartWidgetState extends State<StockChartWidget> {
  List<FlSpot> flSpotValues = <FlSpot>[];
  final List<Color> _gradientColors = [
    const Color(0xFF6FFF7C),
    const Color(0xFF0087FF),
    const Color(0xFF5620FF),
  ];

  final int _divider = 25;
  final int _leftLabelsCount = 6;
  double _minX = 0;
  double _maxX = 0;
  double _minY = double.maxFinite;
  double _maxY = double.minPositive;
  double _leftTitlesInterval = 0;

  @override
  void initState() {
    super.initState();
    _prepareStockData();
  }

  Future<void> _prepareStockData() async {
    flSpotValues = widget.stockChartList.map((item) {
      if (_minY > item.close!) {
        _minY = item.close!.toDouble();
      }
      if (_maxY < item.close!) {
        _maxY = item.close!.toDouble();
      }
      return FlSpot(
        item.date!.millisecondsSinceEpoch.toDouble(),
        item.close!.toDouble(),
      );
    }).toList();

    _minX = flSpotValues.first.x;
    _maxX = flSpotValues.last.x;
    _minY = (_minY / _divider).floorToDouble() * _divider;
    _maxY = (_maxY / _divider).ceilToDouble() * _divider;
    _leftTitlesInterval =
        ((_maxY - _minY) / (_leftLabelsCount - 1)).floorToDouble();

    setState(() {});
  }

  LineChartData _mainData() {
    return LineChartData(
      gridData: _gridData(),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(sideTitles: _bottomTitles()),
        leftTitles: AxisTitles(sideTitles: _leftTitles()),
        rightTitles: const AxisTitles(),
        topTitles: const AxisTitles(),
      ),
      borderData: FlBorderData(
        border: Border.all(),
      ),
      minX: _minX,
      maxX: _maxX,
      minY: _minY,
      maxY: _maxY,
      lineBarsData: <LineChartBarData>[_lineBarData()],
    );
  }

  LineChartBarData _lineBarData() {
    return LineChartBarData(
      spots: flSpotValues,
      gradient: LinearGradient(
        colors: _gradientColors.map((color) => color.withOpacity(0.3)).toList(),
        stops: const [0.25, 0.5, 0.75],
      ),
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors:
              _gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          stops: const [0.25, 0.5, 0.75],
        ),
        // gradientFrom: const Offset(0.5, 0),
        // gradientTo: const Offset(0.5, 1),
      ),
    );
  }

  SideTitles _leftTitles() {
    return SideTitles(
      showTitles: true,
      getTitlesWidget: (double value, TitleMeta meta) {
        return Text(
          '\$${value.round()}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        );
      },
      reservedSize: 36,
      // margin: 12,
      interval: _leftTitlesInterval,
    );
  }

  SideTitles _bottomTitles() {
    return SideTitles(
      showTitles: true,
      getTitlesWidget: (double value, TitleMeta meta) {
        final DateTime date =
            DateTime.fromMillisecondsSinceEpoch(value.toInt());
        return Text(
          DateFormat.MMM().format(date),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        );
      },
      // margin: 8,
      interval: (_maxX - _minX) / 4,
    );
  }

  FlGridData _gridData() {
    return FlGridData(
      drawVerticalLine: false,
      getDrawingHorizontalLine: (value) {
        return const FlLine(
          color: Colors.white12,
          strokeWidth: 1,
        );
      },
      checkToShowHorizontalLine: (value) {
        return (value - _minY) % _leftTitlesInterval != 0;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.80,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child:
            flSpotValues.isEmpty ? const Placeholder() : LineChart(_mainData()),
      ),
    );
  }
}
