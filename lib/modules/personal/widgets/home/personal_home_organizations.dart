import 'package:flutter/material.dart';

import 'package:charitask/modules/organization/data/services/organization_service.dart';

class PersonalHomeOrganizations extends StatefulWidget {
  const PersonalHomeOrganizations({super.key});

  @override
  State<PersonalHomeOrganizations> createState() =>
      _PersonalHomeOrganizationsState();
}

class _PersonalHomeOrganizationsState extends State<PersonalHomeOrganizations> {
  final OrganizationService _organizationService = OrganizationService();

  bool _isLoading = true;
  String? _errorMessage;
  List<OrganizationSummary> _organizations = [];

  @override
  void initState() {
    super.initState();
    _loadOrganizations();
  }

  Future<void> _loadOrganizations() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final organizations = await _organizationService.getMyOrganizations();

      if (!mounted) return;

      setState(() {
        _organizations = organizations;
        _isLoading = false;
      });
    } catch (error) {
      debugPrint('>>> PERSONAL HOME ORGANIZATIONS ERROR: $error');

      if (!mounted) return;

      setState(() {
        _errorMessage = error.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 650;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =============================================================
            // SECTION HEADER
            // =============================================================
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'My Organizations',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF273247),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      color: Color(0xFF6547E8),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // =============================================================
            // CONTENT
            // =============================================================
            if (_isLoading)
              const _OrganizationsLoading()
            else if (_errorMessage != null)
              _OrganizationsError(onRetry: _loadOrganizations)
            else if (_organizations.isEmpty)
              const _OrganizationsEmpty()
            else if (isCompact)
              Column(
                children: [
                  for (int i = 0; i < _organizations.length; i++) ...[
                    _OrganizationCard(organization: _organizations[i]),
                    if (i < _organizations.length - 1)
                      const SizedBox(height: 12),
                  ],
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < _organizations.length; i++) ...[
                    Expanded(
                      child: _OrganizationCard(organization: _organizations[i]),
                    ),
                    if (i < _organizations.length - 1)
                      const SizedBox(width: 16),
                  ],
                ],
              ),
          ],
        );
      },
    );
  }
}

// ===========================================================================
// ORGANIZATION CARD
// ===========================================================================

class _OrganizationCard extends StatelessWidget {
  final OrganizationSummary organization;

  const _OrganizationCard({required this.organization});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF7C4DFF);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE7E8EE)),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.home_work_outlined,
                  color: accent,
                  size: 25,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      organization.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF273247),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      organization.role,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF59677D),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: organization.isActive
                                ? const Color(0xFF32A36A)
                                : const Color(0xFF98A2B3),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          organization.isActive
                              ? 'Active'
                              : organization.status,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: organization.isActive
                                ? const Color(0xFF32A36A)
                                : const Color(0xFF98A2B3),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Color(0xFF98A2B3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// LOADING
// ===========================================================================

class _OrganizationsLoading extends StatelessWidget {
  const _OrganizationsLoading();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7E8EE)),
      ),
      child: const Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: Color(0xFF6547E8),
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// EMPTY
// ===========================================================================

class _OrganizationsEmpty extends StatelessWidget {
  const _OrganizationsEmpty();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7E8EE)),
      ),
      child: const Row(
        children: [
          Icon(Icons.business_outlined, color: Color(0xFF98A2B3), size: 28),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              'You are not currently a member of any organizations.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF59677D),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// ERROR
// ===========================================================================

class _OrganizationsError extends StatelessWidget {
  final VoidCallback onRetry;

  const _OrganizationsError({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7E8EE)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: Color(0xFFE05252)),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Unable to load your organizations.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF273247),
              ),
            ),
          ),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
