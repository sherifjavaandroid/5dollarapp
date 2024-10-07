import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/bloc/company_bloc.dart';
import '../logic/bloc/company_event.dart';
import '../logic/bloc/company_state.dart';
import '../repository/ompany_repository.dart';
import 'company_form.dart';

class CompanyPage extends StatelessWidget {
  const CompanyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CompanyBloc(
        repository: CompanyRepository(),
      )..add(const FetchCompany('1')),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Company Details'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: BlocProvider.of<CompanyBloc>(context),
                      child: const CompanyForm(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocConsumer<CompanyBloc, CompanyState>(
          listener: (context, state) {
            if (state is CompanyDeleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.result.message)),
              );
              if (state.result.rowsAffected != null &&
                  state.result.rowsAffected! > 0) {
                Navigator.of(context).pop();
              }
            } else if (state is CompanyCreated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.result.message)),
              );
              Navigator.of(context).pop();
              context.read<CompanyBloc>().add(FetchCompany(state.result.id));
            } else if (state is CompanyUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.result.message)),
              );
              Navigator.of(context).pop();
              if (state.result.rowsAffected > 0) {
                context.read<CompanyBloc>().add(
                    const FetchCompany('1')); // Refresh the company details
              }
            } else if (state is CompanyError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is CompanyLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CompanyLoaded) {
              final company = state.company;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ID: ${company.id}'),
                    Text('Name (Arabic): ${company.nameA}'),
                    Text('Name (English): ${company.nameE}'),
                    Text('Address (Arabic): ${company.addressA}'),
                    Text('Address (English): ${company.addressE}'),
                    const SizedBox(height: 16),
                    Image.network(company.logo),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BlocProvider.value(
                                  value: BlocProvider.of<CompanyBloc>(context),
                                  child: CompanyForm(company: company),
                                ),
                              ),
                            );
                          },
                          child: const Text('Update Company'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<CompanyBloc>()
                                .add(DeleteCompany(company.id!));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          child: const Text('Delete Company'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
