import 'package:flutter/material.dart';

import '../models/workspace_dashboard_config.dart';

class WorkspaceKpiRow extends StatelessWidget {
  final WorkspaceDashboardConfig config;

  const WorkspaceKpiRow({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88,
      child: Row(
        children: [
          for (var i = 0; i < config.kpis.length; i++) ...[
            Expanded(child: _WorkspaceKpiCard(kpi: config.kpis[i])),
            if (i < config.kpis.length - 1) const SizedBox(width: 12),
          ],
        ],
      ),
    );
  }
}

class _WorkspaceKpiCard extends StatelessWidget {
  final WorkspaceKpiConfig kpi;

  const _WorkspaceKpiCard({required this.kpi});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE1E6F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: kpi.color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(kpi.icon, size: 22, color: kpi.color),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kpi.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 23,
                    height: 1,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF17204D),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  kpi.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF68738A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
