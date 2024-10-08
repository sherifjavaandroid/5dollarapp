import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:developer' as developer;
import '../logic/bloc/company_bloc.dart';
import '../logic/bloc/company_event.dart';
import '../logic/bloc/company_state.dart';
import '../model/company.dart';
import 'company_form.dart';

class CompanyPage extends StatelessWidget {
  const CompanyPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                content: const Text('Update successful, but changes may not be immediately visible. Please refresh.'),
                duration: const Duration(seconds: 5),
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
                duration: const Duration(seconds: 5),
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
                    leading: _buildCompanyLogo(company.logo),
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
                    child: const Text('Retry'),
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

  Widget _buildCompanyLogo(String logoUrl) {
    return FutureBuilder<bool>(
      future: _checkCacheManagerAvailability(),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return CachedNetworkImage(
            imageUrl: logoUrl,
            imageBuilder: (context, imageProvider) => CircleAvatar(
              backgroundImage: imageProvider,
            ),
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) {
              developer.log('Error loading image: $error', name: 'CompanyPage');
              return _buildFallbackImage(logoUrl);
            },
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          );
        } else {
          return _buildFallbackImage(logoUrl);
        }
      },
    );
  }
  Widget _buildFallbackImage(String logoUrl) {
    return CircleAvatar(
      child: Image.network(
        logoUrl,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const CircularProgressIndicator();
        },
        errorBuilder: (context, error, stackTrace) {
          developer.log('Error loading fallback image: $error', name: 'CompanyPage');
          return const Icon(Icons.error, color: Colors.red);
        },
      ),
    );
  }

  Future<bool> _checkCacheManagerAvailability() async {
    try {
      final cacheManager = DefaultCacheManager();
      await cacheManager.getFileFromCache("test");
      return true;
    } catch (e) {
      developer.log('CacheManager not available: $e', name: 'CompanyPage');
      return false;
    }
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
              _buildInfoRow('ID', company.id ?? ''),
              _buildInfoRow('Name (Arabic)', company.nameA),
              _buildInfoRow('Name (English)', company.nameE),
              _buildInfoRow('Address (Arabic)', company.addressA),
              _buildInfoRow('Address (English)', company.addressE),
              const SizedBox(height: 16),
              _buildInfoRow('Logo URL', company.logo),
              const SizedBox(height: 16),
              _buildDetailedCompanyLogo(company.logo),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildDetailedCompanyLogo(String logoUrl) {
    return FutureBuilder<bool>(
      future: _checkCacheManagerAvailability(),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return CachedNetworkImage(
            imageUrl: logoUrl,
            placeholder: (context, url) => const Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 8),
                Text('Loading image...'),
              ],
            ),
            errorWidget: (context, url, error) {
              developer.log('Error loading detailed image: $error', name: 'CompanyPage');
              return Column(
                children: [
                  const Icon(Icons.error, color: Colors.red),
                  const SizedBox(height: 8),
                  Text('Failed to load image: $error'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      CachedNetworkImage.evictFromCache(logoUrl);
                      Navigator.of(context).pop();
                      _showCompanyDetails(context, Company(id: '', nameA: '', nameE: '', addressA: '', addressE: '', logo: logoUrl));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              );
            },
            width: 200,
            fit: BoxFit.contain,
          );
        } else {
          return Image.network(
            logoUrl,
            width: 200,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 8),
                  Text('Loading image...'),
                ],
              );
            },
            errorBuilder: (context, error, stackTrace) {
              developer.log('Error loading detailed fallback image: $error', name: 'CompanyPage');
              return Column(
                children: [
                  const Icon(Icons.error, color: Colors.red),
                  const SizedBox(height: 8),
                  Text('Failed to load image: $error'),
                ],
              );
            },
          );
        }
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}