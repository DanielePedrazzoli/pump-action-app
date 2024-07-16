import 'package:flutter/material.dart';

class SliderDialog extends StatefulWidget {
  final String title;
  final String subtitle;
  final double startingValue;
  final String Function(int) valueDisplayer;
  final int? step;
  final int? max;
  final int? min;
  const SliderDialog({
    super.key,
    required this.startingValue,
    required this.subtitle,
    required this.title,
    required this.valueDisplayer,
    this.step,
    this.max,
    this.min,
  });

  @override
  State<SliderDialog> createState() => _SliderDialogState();
}

class _SliderDialogState extends State<SliderDialog> {
  double value = 0;
  int division = 0;

  @override
  void initState() {
    super.initState();
    value = widget.startingValue;

    division = widget.max! ~/ widget.step!;
  }

  void _updateSliderValue(double newValue) {
    value = newValue.roundToDouble();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(widget.subtitle, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 36),
            Center(
              child: Text(
                widget.valueDisplayer(value.toInt()),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            const SizedBox(height: 36),
            Slider(
              value: value,
              min: widget.min?.toDouble() ?? 0,
              max: widget.max?.toDouble() ?? 0,
              divisions: division,
              onChanged: _updateSliderValue,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () => Navigator.pop(context, null), child: const Text("Annulla")),
                const SizedBox(width: 16),
                FilledButton(onPressed: () => Navigator.pop(context, value.toInt()), child: const Text("Conferma")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
