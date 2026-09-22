import 'package:flutter/material.dart';
import 'package:gestor_de_tareas_personales/core/models/task_model.dart';

class TaskForm extends StatefulWidget {
  const TaskForm({
    super.key,
    required this.onSave,
    required this.buttonLabel,
    this.task,
  });
  final void Function(String title, String description) onSave;
  final String buttonLabel;
  final TaskModel? task;
  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  var _titleController = TextEditingController();
  var _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title);
    _descriptionController = TextEditingController(
      text: widget.task?.description,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (!_formKey.currentState!.validate()) return;
    widget.onSave(title, description);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Título',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: 'Ingresa el título',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'El título es obligatorio';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Descripción',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _descriptionController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Ingresa la descripción',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'La descripción es obligatoria';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitForm,
              child: Text(widget.buttonLabel),
            ),
          ),
        ],
      ),
    );
  }
}
