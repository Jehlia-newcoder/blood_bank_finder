import 'package:flutter/material.dart';

class BloodRequestsListScreen extends StatelessWidget {
  const BloodRequestsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> requests = [
      {
        'patient': 'Jane Smith',
        'type': 'O+',
        'units': '2',
        'status': 'Pending',
      },
      {
        'patient': 'Bob Wilson',
        'type': 'AB-',
        'units': '1',
        'status': 'Completed',
      },
      {
        'patient': 'Alice Brown',
        'type': 'B+',
        'units': '3',
        'status': 'Urgent',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Blood Requests')),
      body: ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final r = requests[index];
          final color = r['status'] == 'Urgent'
              ? Colors.red
              : (r['status'] == 'Pending' ? Colors.orange : Colors.green);

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(r['patient']!),
              subtitle: Text('Type: ${r['type']} • ${r['units']} Units'),
              trailing: Chip(
                label: Text(
                  r['status']!,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                backgroundColor: color,
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Request Details',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Divider(),
                        Text('Patient: ${r['patient']}'),
                        Text('Blood Type: ${r['type']}'),
                        Text('Quantity: ${r['units']} units'),
                        Text('Status: ${r['status']}'),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Close'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Approve'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
