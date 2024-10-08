import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/bloc/company_bloc.dart';
import '../logic/bloc/company_event.dart';
import '../logic/bloc/company_state.dart';
import '../model/company.dart';
import 'company_form.dart';

class CompanyPage extends StatelessWidget {
  const CompanyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch companies when the page is first built
    context.read<CompanyBloc>().add(FetchCompanies());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Companies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CompanyForm(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<CompanyBloc>().add(FetchCompanies());
            },
          ),
        ],
      ),
      body: BlocConsumer<CompanyBloc, CompanyState>(
        listener: (context, state) {
          if (state is CompanyCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.result.message)),
            );
            Navigator.of(context).pop();
          } else if (state is CompanyUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.result.message)),
            );
            Navigator.of(context).pop();
          } else if (state is CompanyUpdatedButNotReflected) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Update successful, but changes may not be immediately visible. Please refresh.'),
                duration: Duration(seconds: 5),
                action: SnackBarAction(
                  label: 'Refresh',
                  onPressed: () {
                    context.read<CompanyBloc>().add(FetchCompanies());
                  },
                ),
              ),
            );
            Navigator.of(context).pop();
          } else if (state is CompanyDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.result.message)),
            );
          } else if (state is CompanyError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                duration: Duration(seconds: 5),
                action: SnackBarAction(
                  label: 'Retry',
                  onPressed: () {
                    context.read<CompanyBloc>().add(FetchCompanies());
                  },
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CompanyLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CompaniesLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<CompanyBloc>().add(FetchCompanies());
              },
              child: ListView.builder(
                itemCount: state.companies.length,
                itemBuilder: (context, index) {
                  final company = state.companies[index];
                  return ListTile(
                    title: Text(company.nameE),
                    subtitle: Text(company.addressE),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CompanyForm(company: company),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _showDeleteConfirmationDialog(context, company);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      _showCompanyDetails(context, company);
                    },
                  );
                },
              ),
            );
          } else if (state is CompanyError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CompanyBloc>().add(FetchCompanies());
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('No companies found'));
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Company company) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete ${company.nameE}?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                context.read<CompanyBloc>().add(DeleteCompany(company.id!));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showCompanyDetails(BuildContext context, Company company) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(company.nameE),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ID: ${company.id}'),
              Text('Name (Arabic): ${company.nameA}'),
              Text('Name (English): ${company.nameE}'),
              Text('Address (Arabic): ${company.addressA}'),
              Text('Address (English): ${company.addressE}'),
              const SizedBox(height: 16),
              Image.network(
                company.logo,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null,
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Text('Error loading image: $error');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}