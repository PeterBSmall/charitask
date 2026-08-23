import 'package:flutter/material.dart';

class PeoplePage extends StatefulWidget {
  const PeoplePage({super.key});

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  int _currentStep = 0;

  final List<String> _steps = const [
    'Basic Information',
    'Connection',
    'Assignments',
    'Access',
    'Review',
    'Create',
  ];

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            const Divider(height: 1),

            _buildProgressIndicator(),

            const SizedBox(height: 24),

            Expanded(child: _buildStepContent()),

            const Divider(height: 1),

            _buildNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          const Icon(Icons.person_add_alt_1, size: 32),

          const SizedBox(width: 16),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Person',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 4),

                Text('Add a new person and connect them to your organization.'),
              ],
            ),
          ),

          TextButton(
            onPressed: () {
              Navigator.of(context).maybePop();
            },
            child: const Text('Cancel'),
          ),

          const SizedBox(width: 12),

          ElevatedButton(
            onPressed: () {
              // Draft functionality will come later.
            },
            child: const Text('Save Draft'),
          ),

          const SizedBox(width: 12),

          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).maybePop();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      child: Row(
        children: List.generate(_steps.length, (index) {
          final isCompleted = index < _currentStep;
          final isCurrent = index == _currentStep;

          return Expanded(
            child: Row(
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: isCurrent || isCompleted
                          ? Colors.deepPurple
                          : Colors.grey.shade300,
                      child: isCompleted
                          ? const Icon(Icons.check, color: Colors.white)
                          : Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: isCurrent ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      _steps[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isCurrent
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),

                if (index < _steps.length - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.only(bottom: 28),
                      color: index < _currentStep
                          ? Colors.deepPurple
                          : Colors.grey.shade300,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildBasicInformation();

      case 1:
        return _buildConnectionStep();

      case 2:
        return _buildAssignmentsStep();

      case 3:
        return _buildPlaceholder('Access');

      case 4:
        return _buildPlaceholder('Review');

      case 5:
        return _buildPlaceholder('Create');

      default:
        return const SizedBox();
    }
  }

  Widget _buildBasicInformation() {
    return const Center(
      child: Text(
        'Basic Information',
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildConnectionStep() {
    return const Center(
      child: Text(
        'Connection',
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildAssignmentsStep() {
    return const Center(
      child: Text(
        'Optional Assignments',
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPlaceholder(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildNavigation() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          if (_currentStep > 0)
            OutlinedButton.icon(
              onPressed: _previousStep,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back'),
            ),

          const Spacer(),

          ElevatedButton.icon(
            onPressed: _currentStep == _steps.length - 1 ? null : _nextStep,
            label: Text(_currentStep == _steps.length - 1 ? 'Create' : 'Next'),
            icon: Icon(
              _currentStep == _steps.length - 1
                  ? Icons.check
                  : Icons.arrow_forward,
            ),
          ),
        ],
      ),
    );
  }
}
