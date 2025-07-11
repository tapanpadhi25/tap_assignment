import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tap_invest_assignment/bloc/company_details_cubit.dart';
import 'package:tap_invest_assignment/utils/custom_container.dart';

import '../bloc/company_details_state.dart';
import '../model/company_details.dart';

class CompanyDetailsScreen extends StatefulWidget {
  const CompanyDetailsScreen({super.key});

  @override
  State<CompanyDetailsScreen> createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CompanyDetailsCubit>().fetchCompanyDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        body: SafeArea(
          top: true,
          child: BlocBuilder<CompanyDetailsCubit, CompanyDetailsState>(
            builder: (context, state) {
              return state.when(
                initial: () => const Center(child: Text("")),
                loading: () => const Center(child: CircularProgressIndicator()),
                loaded: (companyDetails) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black12),
                                color: Colors.white),
                            padding: const EdgeInsets.all(6),
                            child: const Icon(Icons.arrow_back),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                companyDetails.logo,
                                fit: BoxFit.fill,
                              )),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          companyDetails.companyName,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          companyDetails.description,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F0FE),
                                // Light blue background
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child:  Text(
                                "ISIN: ${companyDetails.isin}",
                                style: const TextStyle(
                                  color: Color(0xFF1967D2), // Blue text
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE6F4EA),
                                // Light green background
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child:  Text(
                                companyDetails.status,
                                style: const TextStyle(
                                  color: Color(0xFF137333), // Green text
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const TabBar(
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          labelColor: Color(0xFF1967D2),
                          // Blue for selected tab
                          unselectedLabelColor: Colors.black54,
                          // Grey for unselected tab
                          indicatorColor: Color(0xFF1967D2),
                          // Blue indicator line
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                          tabs: [
                            Tab(text: "ISIN Analysis"),
                            Tab(text: "Pros & Cons"),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                            child: TabBarView(children: [
                          _companyFinancialsAndIssuerDetails(companyDetails),
                          _prosAndConsWidget(companyDetails)
                        ]))
                      ],
                    ),
                  );
                },
                failure: (error) => Center(child: Text("Error: $error")),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _prosAndConsWidget(CompanyDetails company) {
    return CustomContainer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                "Pros and Cons",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // PROS SECTION
            const Text(
              "Pros",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            ...company.prosAndCons.pros.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle,
                        color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        e,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // CONS SECTION
            const Text(
              "Cons",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 8),
            ...company.prosAndCons.cons.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: Colors.orange, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        e,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _companyFinancialsAndIssuerDetails(CompanyDetails company) {
    ValueNotifier<String> selectedTab = ValueNotifier<String>('EBITDA');

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomContainer(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Company Financials",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Toggle Switch
                    ValueListenableBuilder<String>(
                      valueListenable: selectedTab,
                      builder: (context, value, _) {
                        return Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F3F4),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _toggleButton("EBITDA", value == "EBITDA",
                                  () => selectedTab.value = "EBITDA",
                                  isLeft: true),
                              _toggleButton("Revenue", value == "Revenue",
                                  () => selectedTab.value = "Revenue",
                                  isLeft: false),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Chart
                ValueListenableBuilder<String>(
                  valueListenable: selectedTab,
                  builder: (context, value, _) {
                    final isRevenue = value == "Revenue";
                    final data = value == "EBITDA"
                        ? company.financials.ebitda
                        : company.financials.revenue;

                    return financialBarChart(
                      data,
                      yLabelPrefix: "₹",
                      barColor: isRevenue ? Colors.blue : Colors.black87,
                    );
                  },
                ),

                const SizedBox(height: 0),
              ],
            ),
          ),
          // Issuer Details
          const SizedBox(height: 10),
          CustomContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.business, size: 20),
                    SizedBox(width: 8),
                    Text("Issuer Details",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),
                _issuerDetailRow(
                    "Issuer Name", company.issuerDetails.issuerName),
                _issuerDetailRow(
                    "Type of Issuer", company.issuerDetails.typeOfIssuer),
                _issuerDetailRow("Sector", company.issuerDetails.sector),
                _issuerDetailRow("Industry", company.issuerDetails.industry),
                _issuerDetailRow(
                    "Issuer nature", company.issuerDetails.issuerNature),
                _issuerDetailRow("Corporate Identity Number (CIN)",
                    company.issuerDetails.cin),
                _issuerDetailRow("Name of the Lead Manager",
                    company.issuerDetails.leadManager),
                _issuerDetailRow("Registrar", company.issuerDetails.registrar),
                _issuerDetailRow("Name of Debenture Trustee",
                    company.issuerDetails.debentureTrustee),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _issuerDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleButton(
    String label,
    bool selected,
    VoidCallback onTap, {
    required bool isLeft,
  }) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 00),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isLeft ? 20 : 0),
            bottomLeft: Radius.circular(isLeft ? 20 : 0),
            topRight: Radius.circular(!isLeft ? 20 : 0),
            bottomRight: Radius.circular(!isLeft ? 20 : 0),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.black87 : Colors.black45,
          ),
        ),
      ),
    );
  }

  Widget financialBarChart(
    List<MonthlyValue> data, {
    required String yLabelPrefix,
    required Color barColor,
  }) {
    // Get max value from dataset to normalize bar height
    final maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    // Y-Axis Labels (example: ₹1L, ₹2L, ₹3L)
    final yLabels = ['₹3L', '₹2L', '₹1L'];

    return Container(
      height: 200,
      child: Stack(
        children: [
          // Y-Axis Lines and Labels
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: yLabels.map((label) {
                return Row(
                  children: [
                    SizedBox(
                      width: 30,
                      child: Text(
                        label,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade300,
                        thickness: 0.5,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),

          // Bars
          Positioned.fill(
            top: 10,
            left: 40,
            right: 0,
            bottom: 20,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: data.map((entry) {
                  final barHeight = (entry.value / maxValue) * 100;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 12,
                        height: barHeight,
                        decoration: BoxDecoration(
                          color: barColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        entry.month.characters.first,
                        style: const TextStyle(
                            fontSize: 10, color: Colors.black54),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
