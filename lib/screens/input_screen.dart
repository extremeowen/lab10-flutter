import 'package:flutter/material.dart';

import 'preview_screen.dart';

const String kRobotIconUrl =
    'https://emojiisland.com/cdn/shop/products/Robot_Emoji_Icon_abe1111a-1293-4668-bdf9-9ceb05cff58e_large.png?v=1571606090';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _textCtrl = TextEditingController();
  double _fontSize = 34;
  String? _error;

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  Future<void> _openPreview() async {
    final text = _textCtrl.text.trim();
    if (text.isEmpty) {
      setState(() => _error = 'Enter some text');
      return;
    }
    setState(() => _error = null);

    // Чекаємо результат з другого екрана: true (Ok), false (Cancel) або null (назад без кнопок)
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => PreviewScreen(text: text, fontSize: _fontSize),
      ),
    );

    if (!mounted) return;

    String message;
    if (result == true) {
      message = 'Cool!';
    } else if (result == false) {
      message = "Let's try something else";
    } else {
      message = "Don't know what to say";
    }
    _showResultDialog(message);
  }

  void _showResultDialog(String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Image.network(
          kRobotIconUrl,
          width: 56,
          height: 56,
          errorBuilder: (context, error, stack) =>
          const Icon(Icons.smart_toy, size: 56),
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: const Text('Text previewer'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _textCtrl,
                decoration: InputDecoration(
                  labelText: 'Text',
                  helperText: 'Enter some text',
                  errorText: _error,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('Font size: ${_fontSize.round()}'),
                  Expanded(
                    child: Slider(
                      value: _fontSize,
                      min: 10,
                      max: 100,
                      onChanged: (value) => setState(() => _fontSize = value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: _openPreview,
                child: const Text('Preview'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}