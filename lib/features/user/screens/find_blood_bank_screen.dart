import 'package:flutter/material.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../core/utils/ph_locations.dart';

class FindBloodBankScreen extends StatefulWidget {
  const FindBloodBankScreen({super.key});

  @override
  State<FindBloodBankScreen> createState() => _FindBloodBankScreenState();
}

class _FindBloodBankScreenState extends State<FindBloodBankScreen> {
  final List<Map<String, dynamic>> _hospitals = [
    {
      'name': 'St. Luke\'s Medical Center',
      'island': 'Luzon',
      'city': 'Quezon City',
      'barangay': 'Loyola Heights',
      'address': '279 E Rodriguez Sr. Ave',
      'contact': '02-8723-0101',
      'email': 'info@stlukes.com.ph',
      'isActive': true,
      'blood': 'All Types',
    },
    {
      'name': 'Cebu Doctors\' University Hospital',
      'island': 'Visayas',
      'city': 'Cebu City',
      'barangay': 'Lahug',
      'address': 'Osmeña Blvd',
      'contact': '032-255-5555',
      'email': 'contact@cebudoc.com',
      'isActive': true,
      'blood': 'A+, O-, B+',
    },
    {
      'name': 'Davao Doctors Hospital',
      'island': 'Mindanao',
      'city': 'Davao City',
      'barangay': 'Poblacion',
      'address': '118 E. Quirino Ave',
      'contact': '082-222-8000',
      'email': 'help@ddh.com.ph',
      'isActive': false,
      'blood': 'O+, AB-',
    },
  ];

  String _searchQuery = '';
  String _selectedIsland = 'All';
  String? _selectedCity;
  String? _selectedBarangay;

  @override
  Widget build(BuildContext context) {
    final filteredHospitals = _hospitals.where((h) {
      final matchesSearch = h['name']!.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final matchesIsland =
          _selectedIsland == 'All' || h['island'] == _selectedIsland;
      final matchesCity = _selectedCity == null || h['city'] == _selectedCity;
      final matchesBarangay =
          _selectedBarangay == null || h['barangay'] == _selectedBarangay;
      return matchesSearch && matchesIsland && matchesCity && matchesBarangay;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Find Blood Bank')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CustomTextField(
                  label: 'Search Hospital Name',
                  prefixIcon: Icons.search,
                  onChanged: (v) => setState(() => _searchQuery = v),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['All', ...PhLocationData.islandGroups].map((
                      island,
                    ) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(island),
                          selected: _selectedIsland == island,
                          onSelected: (selected) {
                            setState(() {
                              _selectedIsland = island;
                              _selectedCity = null;
                              _selectedBarangay = null;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                if (_selectedIsland != 'All') ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedCity,
                          decoration: const InputDecoration(
                            labelText: 'City',
                            isDense: true,
                          ),
                          items:
                              PhLocationData.getCitiesForIsland(_selectedIsland)
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(
                                        e,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (v) => setState(() {
                            _selectedCity = v;
                            _selectedBarangay = null;
                          }),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedBarangay,
                          decoration: const InputDecoration(
                            labelText: 'Barangay',
                            isDense: true,
                          ),
                          items:
                              PhLocationData.getBarangaysForCity(
                                    _selectedCity ?? '',
                                  )
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(
                                        e,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged: _selectedCity == null
                              ? null
                              : (v) => setState(() => _selectedBarangay = v),
                        ),
                      ),
                      IconButton(
                        onPressed: () => setState(() {
                          _selectedCity = null;
                          _selectedBarangay = null;
                        }),
                        icon: const Icon(Icons.clear, size: 20),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredHospitals.length,
              itemBuilder: (context, index) {
                final h = filteredHospitals[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.redAccent,
                      child: Icon(Icons.local_hospital, color: Colors.white),
                    ),
                    title: Text(
                      h['name']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${h['city']}, ${h['island']}'),
                    trailing: Icon(
                      Icons.circle,
                      size: 12,
                      color: h['isActive'] ? Colors.green : Colors.grey,
                    ),
                    onTap: () => _showHospitalDetails(context, h),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showHospitalDetails(BuildContext context, Map<String, dynamic> h) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    h['name'],
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: h['isActive'] ? Colors.green[50] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: h['isActive'] ? Colors.green : Colors.grey,
                    ),
                  ),
                  child: Text(
                    h['isActive'] ? 'ACTIVE' : 'INACTIVE',
                    style: TextStyle(
                      color: h['isActive'] ? Colors.green : Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            _detailItem(
              Icons.location_on,
              'Address',
              '${h['address']}, Brgy. ${h['barangay']}, ${h['city']}, ${h['island']}',
            ),
            _detailItem(Icons.phone, 'Contact', h['contact']),
            _detailItem(Icons.email, 'Email', h['email']),
            _detailItem(Icons.bloodtype, 'Availability', h['blood']),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    label: const Text('Close'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.call),
                    label: const Text('Contact Now'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.redAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(value, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
