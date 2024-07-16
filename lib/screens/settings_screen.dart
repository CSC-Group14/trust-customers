import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final Color themeColor;
  final Function(Color) updateTheme;
  final Function(String) updateLanguage;
  final Function(String) updateFontStyle;
  final Function(double) updateFontSize;

  SettingsScreen({
    required this.themeColor,
    required this.updateTheme,
    required this.updateLanguage,
    required this.updateFontStyle,
    required this.updateFontSize,
  });

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Color _selectedColor;
  late String _selectedLanguage;
  late String _selectedFontStyle;
  late double _selectedFontSize;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.themeColor;
    _selectedLanguage = 'English';
    _selectedFontStyle = 'Sans';
    _selectedFontSize = 16.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: _selectedColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildColorPicker(),
            _buildLanguageDropdown(),
            _buildFontStyleDropdown(),
            _buildFontSizeSlider(),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
    return ListTile(
      title: Text('App Theme Color'),
      trailing: CircleAvatar(
        backgroundColor: _selectedColor,
      ),
      onTap: () async {
        Color? color = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Select Theme Color'),
            content: BlockPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) {
                setState(() {
                  _selectedColor = color;
                });
                Navigator.of(context).pop(color);
              },
            ),
          ),
        );
        if (color != null) {
          setState(() {
            _selectedColor = color;
          });
          widget.updateTheme(_selectedColor);
        }
      },
    );
  }

  Widget _buildLanguageDropdown() {
    return ListTile(
      title: Text('Language'),
      trailing: DropdownButton<String>(
        value: _selectedLanguage,
        items: ['English', 'Spanish', 'French', 'German']
            .map((String language) {
          return DropdownMenuItem<String>(
            value: language,
            child: Text(language),
          );
        }).toList(),
        onChanged: (String? newLanguage) {
          setState(() {
            _selectedLanguage = newLanguage!;
          });
          widget.updateLanguage(_selectedLanguage);
        },
      ),
    );
  }

  Widget _buildFontStyleDropdown() {
    return ListTile(
      title: Text('Font Style'),
      trailing: DropdownButton<String>(
        value: _selectedFontStyle,
        items: ['Sans', 'Serif', 'Monospace']
            .map((String style) {
          return DropdownMenuItem<String>(
            value: style,
            child: Text(style),
          );
        }).toList(),
        onChanged: (String? newStyle) {
          setState(() {
            _selectedFontStyle = newStyle!;
          });
          widget.updateFontStyle(_selectedFontStyle);
        },
      ),
    );
  }

  Widget _buildFontSizeSlider() {
    return ListTile(
      title: Text('Font Size'),
      subtitle: Slider(
        value: _selectedFontSize,
        min: 12.0,
        max: 24.0,
        divisions: 12,
        label: _selectedFontSize.toString(),
        onChanged: (double newSize) {
          setState(() {
            _selectedFontSize = newSize;
          });
          widget.updateFontSize(_selectedFontSize);
        },
      ),
    );
  }
}

class BlockPicker extends StatelessWidget {
  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;

  BlockPicker({required this.pickerColor, required this.onColorChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      child: GridView.count(
        crossAxisCount: 4,
        children: [
          _buildColorBlock(Colors.red),
          _buildColorBlock(Colors.green),
          _buildColorBlock(Colors.blue),
          _buildColorBlock(Colors.yellow),
          _buildColorBlock(Colors.orange),
          _buildColorBlock(Colors.purple),
          _buildColorBlock(Colors.brown),
          _buildColorBlock(Colors.pink),
          _buildColorBlock(Colors.cyan),
          _buildColorBlock(Colors.lime),
          _buildColorBlock(Colors.indigo),
          _buildColorBlock(Colors.teal),
        ],
      ),
    );
  }

  Widget _buildColorBlock(Color color) {
    return GestureDetector(
      onTap: () => onColorChanged(color),
      child: Container(
        margin: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: Colors.black,
            width: pickerColor == color ? 3.0 : 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
