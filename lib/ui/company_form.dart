import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/bloc/company_bloc.dart';
import '../logic/bloc/company_event.dart';
import '../model/company.dart';

class CompanyForm extends StatefulWidget {
  final Company? company;

  const CompanyForm({Key? key, this.company}) : super(key: key);

  @override
  _CompanyFormState createState() => _CompanyFormState();
}

class _CompanyFormState extends State<CompanyForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameAController;
  late TextEditingController _nameEController;
  late TextEditingController _addressAController;
  late TextEditingController _addressEController;
  late TextEditingController _logoController;

  @override
  void initState() {
    super.initState();
    _nameAController = TextEditingController(text: widget.company?.nameA);
    _nameEController = TextEditingController(text: widget.company?.nameE);
    _addressAController = TextEditingController(text: widget.company?.addressA);
    _addressEController = TextEditingController(text: widget.company?.addressE);
    _logoController = TextEditingController(text: widget.company?.logo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.company == null ? 'Create Company' : 'Update Company'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameAController,
              decoration: const InputDecoration(labelText: 'Name (Arabic)'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the Arabic name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _nameEController,
              decoration: const InputDecoration(labelText: 'Name (English)'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the English name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _addressAController,
              decoration: const InputDecoration(labelText: 'Address (Arabic)'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the Arabic address';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _addressEController,
              decoration: const InputDecoration(labelText: 'Address (English)'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the English address';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _logoController,
              decoration: const InputDecoration(labelText: 'Logo URL'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the logo URL';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final company = Company(
                    id: widget.company?.id,
                    nameA: _nameAController.text,
                    nameE: _nameEController.text,
                    addressA: _addressAController.text,
                    addressE: _addressEController.text,
                    logo: _logoController.text,
                  );
                  if (widget.company == null) {
                    context.read<CompanyBloc>().add(CreateCompany(company));
                  } else {
                    context.read<CompanyBloc>().add(UpdateCompany(widget.company!.id!, company));
                  }
                }
              },
              child: Text(widget.company == null ? 'Create Company' : 'Update Company'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameAController.dispose();
    _nameEController.dispose();
    _addressAController.dispose();
    _addressEController.dispose();
    _logoController.dispose();
    super.dispose();
  }
}