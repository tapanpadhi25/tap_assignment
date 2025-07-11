import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tap_invest_assignment/bloc/company_cubit.dart';
import 'package:tap_invest_assignment/bloc/company_state.dart';
import 'package:tap_invest_assignment/screens/company_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CompanyCubit>().fetchIssuers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Home",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                onChanged: (value) =>
                    context.read<CompanyCubit>().search(value),
                decoration: InputDecoration(
                  hintText: 'Search by Issuer Name or ISIN',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text("SEARCH RESULTS",
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Expanded(
                child: BlocBuilder<CompanyCubit, CompanyState>(
                  builder: (context, state) {
                    return state.when(
                      initial: () => const SizedBox(),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      failure: (msg) => Center(child: Text(msg)),
                      loaded: (_, filtered) => ListView.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, index) {
                          final item = filtered[index];
                          return ListTile(
                              tileColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                              leading: CircleAvatar(
                                  backgroundImage: NetworkImage(item.logo)),
                              title: Text(item.isin,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                  '${item.rating} • ${item.companyName}',
                                  style: const TextStyle(color: Colors.grey)),
                              trailing:
                                  const Icon(Icons.arrow_forward_ios, size: 16),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const CompanyDetailsScreen()));
                              });
                        },
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
