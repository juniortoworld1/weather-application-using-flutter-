import 'package:flutter/material.dart';

class Inputfields extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Function(String)? onSubmitted;

  const Inputfields({
    super.key,
    required this.onSubmitted,
    required this.label,
    required this.controller,
    this.hint = '',
    this.keyboardType = TextInputType.text,
  });

  @override
  State<Inputfields> createState() => _InputfieldsState();
}

class _InputfieldsState extends State<Inputfields> with SingleTickerProviderStateMixin {
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        isExpanded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 4),
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
          BoxShadow(
            blurRadius: 15,
            blurStyle: BlurStyle.outer,
            spreadRadius: 5,
          )
        ],
        gradient: LinearGradient(
          colors: const [Colors.blue, Colors.purple],
          begin: isExpanded ? Alignment.topLeft : Alignment.bottomRight,
          end: isExpanded ? Alignment.bottomRight : Alignment.topLeft,
        ),
      ),
      onEnd: () => setState(() => isExpanded = !isExpanded),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1C2E),
          borderRadius: BorderRadius.circular(11.0),
        ),
        child: TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          onFieldSubmitted: widget.onSubmitted,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: const TextStyle(color: Colors.white70),
            hintText: widget.hint,
            hintStyle: const TextStyle(color: Colors.white30),
            suffixIcon: InkWell(
              onTap: () {
                if (widget.onSubmitted != null) {
                  widget.onSubmitted!(widget.controller.text);
                }
              },
              borderRadius: BorderRadius.circular(12.0),
              child: const Icon(Icons.search, color: Colors.white),
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          ),
        ),
      ),
    );
  }
}