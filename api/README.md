# Operation catalog

380 documentation/CLI/live-verified bindings and native methods. See [coverage](../COVERAGE.md), [native API](../API.md), [inference](../INFERENCE.md), and [management](../MANAGEMENT.md).

| Name | Method | Path | Surface | Source |
| --- | --- | --- | --- | --- |
| `delete_billing_budgets_id` | DELETE | `/billing/budgets/{id}` | dashboard | [source](https://erebine.ai/docs/budget-alerts) |
| `delete_chat_api_id_1_branch_id_2` | DELETE | `/chat/api/{id_1}/branch/{id_2}` | dashboard | [source](https://erebine.ai/docs/chat-branching) |
| `delete_chat_api_id_1_memories_id_2` | DELETE | `/chat/api/{id_1}/memories/{id_2}` | dashboard | [source](https://erebine.ai/docs/chat-memory) |
| `delete_chat_api_workspaces_id` | DELETE | `/chat/api/workspaces/{id}` | dashboard | [source](https://erebine.ai/docs/document-workspace) |
| `delete_chat_api_workspaces_id_1_decisions_id_2` | DELETE | `/chat/api/workspaces/{id_1}/decisions/{id_2}` | dashboard | [source](https://erebine.ai/docs/document-workspace) |
| `delete_chat_api_workspaces_id_1_files_id_2` | DELETE | `/chat/api/workspaces/{id_1}/files/{id_2}` | dashboard | [source](https://erebine.ai/docs/document-workspace) |
| `delete_chat_api_workspaces_id_1_members_id_2` | DELETE | `/chat/api/workspaces/{id_1}/members/{id_2}` | dashboard | [source](https://erebine.ai/docs/document-workspace) |
| `delete_chat_api_workspaces_id_1_memories_id_2` | DELETE | `/chat/api/workspaces/{id_1}/memories/{id_2}` | dashboard | [source](https://erebine.ai/docs/chat-memory), [source](https://erebine.ai/docs/document-workspace) |
| `delete_chat_api_workspaces_id_1_milestones_id_2` | DELETE | `/chat/api/workspaces/{id_1}/milestones/{id_2}` | dashboard | [source](https://erebine.ai/docs/document-workspace) |
| `delete_chat_api_workspaces_id_1_relations_id_2` | DELETE | `/chat/api/workspaces/{id_1}/relations/{id_2}` | dashboard | [source](https://erebine.ai/docs/document-workspace) |
| `delete_gdpr_export_id` | DELETE | `/gdpr/export/{id}` | dashboard | [source](https://erebine.ai/docs/data-export) |
| `delete_project_id_endpoint_slug_v1_chat_completions_id` | DELETE | `/{project_id}/{endpoint_slug}/v1/chat/completions/{id}` | router | [source](https://erebine.ai/docs/completions), [source](https://erebine.ai/docs/tool-calling), [source](https://erebine.ai/docs/zero-data-retention), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `delete_project_id_endpoint_slug_v1_responses_id` | DELETE | `/{project_id}/{endpoint_slug}/v1/responses/{id}` | router | [source](https://erebine.ai/docs/responses), [source](https://erebine.ai/docs/zero-data-retention), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `delete_project_id_v1_admin_maintenance_windows_id` | DELETE | `/{project_id}/v1/admin/maintenance/windows/{id}` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `delete_project_id_v1_admin_storage_tiers_id` | DELETE | `/{project_id}/v1/admin/storage-tiers/{id}` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `delete_project_id_v1_chat_templates_id` | DELETE | `/{project_id}/v1/chat-templates/{id}` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `delete_project_id_v1_chats_id` | DELETE | `/{project_id}/v1/chats/{id}` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `delete_project_id_v1_chats_id_1_artifacts_id_2` | DELETE | `/{project_id}/v1/chats/{id_1}/artifacts/{id_2}` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `delete_project_id_v1_chats_id_1_branches_id_2` | DELETE | `/{project_id}/v1/chats/{id_1}/branches/{id_2}` | router | [source](https://erebine.ai/docs/chat-branching) |
| `delete_project_id_v1_chats_id_1_members_id_2` | DELETE | `/{project_id}/v1/chats/{id_1}/members/{id_2}` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `delete_project_id_v1_chats_id_exec_workspace` | DELETE | `/{project_id}/v1/chats/{id}/exec-workspace` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `delete_project_id_v1_conversations_id` | DELETE | `/{project_id}/v1/conversations/{id}` | router | [source](https://erebine.ai/docs/conversations), [source](https://erebine.ai/docs/erectl/conversations), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `delete_project_id_v1_conversations_id_1_items_id_2` | DELETE | `/{project_id}/v1/conversations/{id_1}/items/{id_2}` | router | [source](https://erebine.ai/docs/conversations), [source](https://erebine.ai/docs/erectl/conversations), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `delete_project_id_v1_exports_id` | DELETE | `/{project_id}/v1/exports/{id}` | router | [source](https://erebine.ai/docs/data-export), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `delete_project_id_v1_files_id` | DELETE | `/{project_id}/v1/files/{id}` | router | [source](https://erebine.ai/docs/files), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `delete_project_id_v1_management_agents_id` | DELETE | `/{project_id}/v1/management/agents/{id}` | router | [source](https://erebine.ai/docs/private-agents), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `delete_project_id_v1_management_api_keys_id` | DELETE | `/{project_id}/v1/management/api-keys/{id}` | router | [source](https://erebine.ai/docs/erectl/keys), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `delete_project_id_v1_management_endpoints_id` | DELETE | `/{project_id}/v1/management/endpoints/{id}` | router | [source](https://erebine.ai/docs/endpoint-cors), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `delete_project_id_v1_management_endpoints_id_1_agents_id_2` | DELETE | `/{project_id}/v1/management/endpoints/{id_1}/agents/{id_2}` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `delete_project_id_v1_management_join_keys_id` | DELETE | `/{project_id}/v1/management/join-keys/{id}` | router | [source](https://erebine.ai/docs/private-agents), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `delete_project_id_v1_management_maintenance_id` | DELETE | `/{project_id}/v1/management/maintenance/{id}` | router | [source](https://erebine.ai/docs/status-maintenance), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `delete_project_id_v1_management_project_invitations_id` | DELETE | `/{project_id}/v1/management/project/invitations/{id}` | router | [source](https://erebine.ai/docs/teams), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `delete_project_id_v1_management_project_members_id` | DELETE | `/{project_id}/v1/management/project/members/{id}` | router | [source](https://erebine.ai/docs/teams), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `delete_project_id_v1_management_semantic_router_rules_id` | DELETE | `/{project_id}/v1/management/semantic-router/rules/{id}` | router | [source](https://erebine.ai/docs/api-reference), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `delete_project_id_v1_mcp` | DELETE | `/{project_id}/v1/mcp` | router | [source](https://erebine.ai/docs/mcp), [source](https://modelcontextprotocol.io/specification/2025-06-18/basic/transports) |
| `delete_project_id_v1_models_id` | DELETE | `/{project_id}/v1/models/{id}` | router | [source](https://erebine.ai/docs/erectl/models), [source](https://erebine.ai/docs/model-management), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `delete_project_id_v1_settings_project` | DELETE | `/{project_id}/v1/settings/project` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `delete_project_id_v1_slos_id` | DELETE | `/{project_id}/v1/slos/{id}` | router | [source](https://erebine.ai/docs/slo-tracking), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `delete_project_id_v1_uploads_id` | DELETE | `/{project_id}/v1/uploads/{id}` | router | [source](https://erebine.ai/docs/erectl/uploads), [source](https://erebine.ai/docs/uploads), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `delete_project_id_v1_webhooks_id` | DELETE | `/{project_id}/v1/webhooks/{id}` | router | [source](https://erebine.ai/docs/webhooks), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `delete_project_id_v1_workspaces_id` | DELETE | `/{project_id}/v1/workspaces/{id}` | router | [source](https://erebine.ai/docs/document-workspace), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `delete_project_id_v1_workspaces_id_1_agents_id_2` | DELETE | `/{project_id}/v1/workspaces/{id_1}/agents/{id_2}` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `delete_project_id_v1_workspaces_id_1_auto_approvals_id_2` | DELETE | `/{project_id}/v1/workspaces/{id_1}/auto-approvals/{id_2}` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `delete_project_id_v1_workspaces_id_1_chat_templates_id_2` | DELETE | `/{project_id}/v1/workspaces/{id_1}/chat-templates/{id_2}` | router | [source](https://erebine.ai/docs/erectl/templates) |
| `delete_project_id_v1_workspaces_id_1_decisions_id_2` | DELETE | `/{project_id}/v1/workspaces/{id_1}/decisions/{id_2}` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `delete_project_id_v1_workspaces_id_1_files_id_2` | DELETE | `/{project_id}/v1/workspaces/{id_1}/files/{id_2}` | router | [source](https://erebine.ai/docs/document-workspace) |
| `delete_project_id_v1_workspaces_id_1_members_id_2` | DELETE | `/{project_id}/v1/workspaces/{id_1}/members/{id_2}` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `delete_project_id_v1_workspaces_id_1_memories_id_2` | DELETE | `/{project_id}/v1/workspaces/{id_1}/memories/{id_2}` | router | [source](https://erebine.ai/docs/chat-memory), [source](https://erebine.ai/docs/document-workspace), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `delete_project_id_v1_workspaces_id_1_milestones_id_2` | DELETE | `/{project_id}/v1/workspaces/{id_1}/milestones/{id_2}` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `delete_project_id_workspace_id_direct_v1_responses_id` | DELETE | `/{project_id}/{workspace_id}/_direct/v1/responses/{id}` | router | [source](https://erebine.ai/docs/direct) |
| `get_account_api_invite` | GET | `/account/api/invite` | dashboard | [source](https://erebine.ai/docs/teams) |
| `get_billing` | GET | `/billing` | dashboard | [source](https://erebine.ai/docs/billing-subscriptions) |
| `get_billing_budgets` | GET | `/billing/budgets` | dashboard | [source](https://erebine.ai/docs/budget-alerts) |
| `get_billing_budgets_id` | GET | `/billing/budgets/{id}` | dashboard | [source](https://erebine.ai/docs/budget-alerts) |
| `get_billing_budgets_id_history` | GET | `/billing/budgets/{id}/history` | dashboard | [source](https://erebine.ai/docs/budget-alerts) |
| `get_billing_checkout_cancel` | GET | `/billing/checkout/cancel` | dashboard | [source](https://erebine.ai/docs/billing-subscriptions) |
| `get_billing_checkout_success` | GET | `/billing/checkout/success` | dashboard | [source](https://erebine.ai/docs/billing-subscriptions) |
| `get_billing_invoices` | GET | `/billing/invoices` | dashboard | [source](https://erebine.ai/docs/billing-subscriptions) |
| `get_billing_plans` | GET | `/billing/plans` | dashboard | [source](https://erebine.ai/docs/billing-subscriptions) |
| `get_chat_api_id_branches` | GET | `/chat/api/{id}/branches` | dashboard | [source](https://erebine.ai/docs/chat-branching) |
| `get_chat_api_id_memories` | GET | `/chat/api/{id}/memories` | dashboard | [source](https://erebine.ai/docs/chat-memory) |
| `get_chat_api_templates` | GET | `/chat/api/templates` | dashboard | [source](https://erebine.ai/docs/chat-branching) |
| `get_chat_api_workspaces` | GET | `/chat/api/workspaces` | dashboard | [source](https://erebine.ai/docs/document-workspace) |
| `get_chat_api_workspaces_id` | GET | `/chat/api/workspaces/{id}` | dashboard | [source](https://erebine.ai/docs/document-workspace) |
| `get_chat_api_workspaces_id_1_files_id_2` | GET | `/chat/api/workspaces/{id_1}/files/{id_2}` | dashboard | [source](https://erebine.ai/docs/document-workspace) |
| `get_chat_api_workspaces_id_decisions` | GET | `/chat/api/workspaces/{id}/decisions` | dashboard | [source](https://erebine.ai/docs/document-workspace) |
| `get_chat_api_workspaces_id_files` | GET | `/chat/api/workspaces/{id}/files` | dashboard | [source](https://erebine.ai/docs/document-workspace) |
| `get_chat_api_workspaces_id_graph` | GET | `/chat/api/workspaces/{id}/graph` | dashboard | [source](https://erebine.ai/docs/workspace-graph) |
| `get_chat_api_workspaces_id_members` | GET | `/chat/api/workspaces/{id}/members` | dashboard | [source](https://erebine.ai/docs/document-workspace) |
| `get_chat_api_workspaces_id_memories` | GET | `/chat/api/workspaces/{id}/memories` | dashboard | [source](https://erebine.ai/docs/chat-memory), [source](https://erebine.ai/docs/document-workspace) |
| `get_chat_api_workspaces_id_milestones` | GET | `/chat/api/workspaces/{id}/milestones` | dashboard | [source](https://erebine.ai/docs/document-workspace) |
| `get_chat_api_workspaces_id_preferences` | GET | `/chat/api/workspaces/{id}/preferences` | dashboard | [source](https://erebine.ai/docs/document-workspace) |
| `get_gdpr_delete_id` | GET | `/gdpr/delete/{id}` | dashboard | [source](https://erebine.ai/docs/data-export) |
| `get_gdpr_delete_preview` | GET | `/gdpr/delete/preview` | dashboard | [source](https://erebine.ai/docs/data-export) |
| `get_gdpr_export_id` | GET | `/gdpr/export/{id}` | dashboard | [source](https://erebine.ai/docs/data-export) |
| `get_gdpr_export_id_download` | GET | `/gdpr/export/{id}/download` | dashboard | [source](https://erebine.ai/docs/data-export) |
| `get_gdpr_exports` | GET | `/gdpr/exports` | dashboard | [source](https://erebine.ai/docs/data-export) |
| `get_healthz` | GET | `/healthz` | router | [source](https://erebine.ai/docs/status-maintenance) |
| `get_ops_api_activity_export` | GET | `/ops/api/activity/export` | dashboard | [source](https://erebine.ai/docs/eem/ops-dashboard) |
| `get_project_id_direct_v1_provider_manifest` | GET | `/{project_id}/_direct/v1/provider-manifest` | router | [source](https://erebine.ai/docs/direct) |
| `get_project_id_endpoint_slug_v1_chat_completions` | GET | `/{project_id}/{endpoint_slug}/v1/chat/completions` | router | [source](https://erebine.ai/docs/completions), [source](https://erebine.ai/docs/tool-calling), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_endpoint_slug_v1_chat_completions_id` | GET | `/{project_id}/{endpoint_slug}/v1/chat/completions/{id}` | router | [source](https://erebine.ai/docs/completions), [source](https://erebine.ai/docs/sdk-integrations), [source](https://erebine.ai/docs/tool-calling), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_endpoint_slug_v1_chat_completions_id_messages` | GET | `/{project_id}/{endpoint_slug}/v1/chat/completions/{id}/messages` | router | [source](https://erebine.ai/docs/completions), [source](https://erebine.ai/docs/tool-calling), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_endpoint_slug_v1_models` | GET | `/{project_id}/{endpoint_slug}/v1/models` | router | [source](https://erebine.ai/docs/getting-started), [source](https://erebine.ai/docs/sdk-integrations) |
| `get_project_id_endpoint_slug_v1_models_id` | GET | `/{project_id}/{endpoint_slug}/v1/models/{id}` | router | [source](https://erebine.ai/docs/sdk-integrations) |
| `get_project_id_endpoint_slug_v1_responses` | GET | `/{project_id}/{endpoint_slug}/v1/responses` | router | [source](https://erebine.ai/docs/responses), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_endpoint_slug_v1_responses_id` | GET | `/{project_id}/{endpoint_slug}/v1/responses/{id}` | router | [source](https://erebine.ai/docs/responses), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_endpoint_slug_v1_responses_id_input_items` | GET | `/{project_id}/{endpoint_slug}/v1/responses/{id}/input_items` | router | [source](https://erebine.ai/docs/responses), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_admin_anchors` | GET | `/{project_id}/v1/admin/anchors` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_admin_anchors_id` | GET | `/{project_id}/v1/admin/anchors/{id}` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_admin_cache_keys` | GET | `/{project_id}/v1/admin/cache/keys` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_admin_cache_stats` | GET | `/{project_id}/v1/admin/cache/stats` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_admin_consumption` | GET | `/{project_id}/v1/admin/consumption` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_admin_health` | GET | `/{project_id}/v1/admin/health` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_admin_maintenance_windows` | GET | `/{project_id}/v1/admin/maintenance/windows` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_admin_maintenance_windows_id` | GET | `/{project_id}/v1/admin/maintenance/windows/{id}` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_admin_private_agents` | GET | `/{project_id}/v1/admin/private-agents` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_admin_project_endpoints` | GET | `/{project_id}/v1/admin/project-endpoints` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_admin_storage_dashboard` | GET | `/{project_id}/v1/admin/storage/dashboard` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_admin_storage_tiers` | GET | `/{project_id}/v1/admin/storage-tiers` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_admin_users` | GET | `/{project_id}/v1/admin/users` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_batches` | GET | `/{project_id}/v1/batches` | router | [source](https://erebine.ai/docs/batch), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_batches_id` | GET | `/{project_id}/v1/batches/{id}` | router | [source](https://erebine.ai/docs/batch), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_chat_templates` | GET | `/{project_id}/v1/chat-templates` | router | [source](https://erebine.ai/docs/erectl/templates), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_chat_templates_id` | GET | `/{project_id}/v1/chat-templates/{id}` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_chat_templates_id_versions` | GET | `/{project_id}/v1/chat-templates/{id}/versions` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_chats` | GET | `/{project_id}/v1/chats` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_chats_id` | GET | `/{project_id}/v1/chats/{id}` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_chats_id_artifacts` | GET | `/{project_id}/v1/chats/{id}/artifacts` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_chats_id_branches` | GET | `/{project_id}/v1/chats/{id}/branches` | router | [source](https://erebine.ai/docs/chat-branching), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_chats_id_context` | GET | `/{project_id}/v1/chats/{id}/context` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_chats_id_exec_workspace` | GET | `/{project_id}/v1/chats/{id}/exec-workspace` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_chats_id_members` | GET | `/{project_id}/v1/chats/{id}/members` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_chats_id_memories` | GET | `/{project_id}/v1/chats/{id}/memories` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_chats_id_messages` | GET | `/{project_id}/v1/chats/{id}/messages` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_conversations` | GET | `/{project_id}/v1/conversations` | router | [source](https://erebine.ai/docs/conversations), [source](https://erebine.ai/docs/erectl/conversations), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_conversations_id` | GET | `/{project_id}/v1/conversations/{id}` | router | [source](https://erebine.ai/docs/conversations), [source](https://erebine.ai/docs/erectl/conversations), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_conversations_id_1_items_id_2` | GET | `/{project_id}/v1/conversations/{id_1}/items/{id_2}` | router | [source](https://erebine.ai/docs/conversations) |
| `get_project_id_v1_conversations_id_items` | GET | `/{project_id}/v1/conversations/{id}/items` | router | [source](https://erebine.ai/docs/conversations), [source](https://erebine.ai/docs/erectl/conversations), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_endpoints` | GET | `/{project_id}/v1/endpoints` | router | [source](https://erebine.ai/docs/api-reference), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_endpoints_id_slos` | GET | `/{project_id}/v1/endpoints/{id}/slos` | router | [source](https://erebine.ai/docs/slo-tracking) |
| `get_project_id_v1_exec_agents_id_manifest` | GET | `/{project_id}/v1/exec/agents/{id}/manifest` | router | [source](https://erebine.ai/docs/erectl/exec) |
| `get_project_id_v1_exec_approvals` | GET | `/{project_id}/v1/exec/approvals` | router | [source](https://erebine.ai/docs/eem/approvals), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_exec_approvals_id` | GET | `/{project_id}/v1/exec/approvals/{id}` | router | [source](https://erebine.ai/docs/eem/approvals), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_exec_approvals_stream` | GET | `/{project_id}/v1/exec/approvals/stream` | router | [source](https://erebine.ai/docs/eem/approvals) |
| `get_project_id_v1_exec_invocations` | GET | `/{project_id}/v1/exec/invocations` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_exec_invocations_id` | GET | `/{project_id}/v1/exec/invocations/{id}` | router | [source](https://erebine.ai/docs/eem), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_exec_learnings` | GET | `/{project_id}/v1/exec/learnings` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_exec_learnings_id` | GET | `/{project_id}/v1/exec/learnings/{id}` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_exec_tools` | GET | `/{project_id}/v1/exec/tools` | router | [source](https://erebine.ai/docs/eem), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_exec_tools_id` | GET | `/{project_id}/v1/exec/tools/{id}` | router | [source](https://erebine.ai/docs/erectl/exec), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_exports` | GET | `/{project_id}/v1/exports` | router | [source](https://erebine.ai/docs/data-export) |
| `get_project_id_v1_exports_id` | GET | `/{project_id}/v1/exports/{id}` | router | [source](https://erebine.ai/docs/data-export), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_exports_id_download` | GET | `/{project_id}/v1/exports/{id}/download` | router | [source](https://erebine.ai/docs/data-export), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_files` | GET | `/{project_id}/v1/files` | router | [source](https://erebine.ai/docs/files), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_files_id` | GET | `/{project_id}/v1/files/{id}` | router | [source](https://erebine.ai/docs/files), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_files_id_content` | GET | `/{project_id}/v1/files/{id}/content` | router | [source](https://erebine.ai/docs/api-reference), [source](https://erebine.ai/docs/files), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_health_dashboard` | GET | `/{project_id}/v1/health/dashboard` | router | [source](https://erebine.ai/docs/erectl/platform), [source](https://erebine.ai/docs/status-maintenance), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_management_agents` | GET | `/{project_id}/v1/management/agents` | router | [source](https://erebine.ai/docs/private-agents), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_management_agents_id` | GET | `/{project_id}/v1/management/agents/{id}` | router | [source](https://erebine.ai/docs/private-agents), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_management_agents_id_events` | GET | `/{project_id}/v1/management/agents/{id}/events` | router | [source](https://erebine.ai/docs/eem/guide/credential-rotation), [source](https://erebine.ai/docs/private-agents), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_management_agents_id_logs_stream` | GET | `/{project_id}/v1/management/agents/{id}/logs/stream` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_management_api_keys` | GET | `/{project_id}/v1/management/api-keys` | router | [source](https://erebine.ai/docs/erectl/keys), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_management_api_keys_id` | GET | `/{project_id}/v1/management/api-keys/{id}` | router | [source](https://erebine.ai/docs/erectl/keys), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_management_endpoints` | GET | `/{project_id}/v1/management/endpoints` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_management_endpoints_id` | GET | `/{project_id}/v1/management/endpoints/{id}` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_management_endpoints_id_agents` | GET | `/{project_id}/v1/management/endpoints/{id}/agents` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_management_endpoints_id_cors` | GET | `/{project_id}/v1/management/endpoints/{id}/cors` | router | [source](https://erebine.ai/docs/endpoint-cors), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_management_endpoints_id_health_check` | GET | `/{project_id}/v1/management/endpoints/{id}/health/check` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_management_endpoints_id_health_config` | GET | `/{project_id}/v1/management/endpoints/{id}/health/config` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_management_evolution_id` | GET | `/{project_id}/v1/management/evolution/{id}` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_management_evolution_id_1_lane_runs_id_2` | GET | `/{project_id}/v1/management/evolution/{id_1}/{lane}/runs/{id_2}` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_management_evolution_id_lane_active` | GET | `/{project_id}/v1/management/evolution/{id}/{lane}/active` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_management_evolution_id_lane_history` | GET | `/{project_id}/v1/management/evolution/{id}/{lane}/history` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_management_join_keys` | GET | `/{project_id}/v1/management/join-keys` | router | [source](https://erebine.ai/docs/private-agents), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_management_maintenance` | GET | `/{project_id}/v1/management/maintenance` | router | [source](https://erebine.ai/docs/status-maintenance), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_management_project_invitations` | GET | `/{project_id}/v1/management/project/invitations` | router | [source](https://erebine.ai/docs/teams), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_management_project_members` | GET | `/{project_id}/v1/management/project/members` | router | [source](https://erebine.ai/docs/teams), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_management_semantic_router_config` | GET | `/{project_id}/v1/management/semantic-router/config` | router | [source](https://erebine.ai/docs/api-reference), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_management_semantic_router_decisions` | GET | `/{project_id}/v1/management/semantic-router/decisions` | router | [source](https://erebine.ai/docs/api-reference), [source](https://erebine.ai/docs/authentication), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_management_semantic_router_health` | GET | `/{project_id}/v1/management/semantic-router/health` | router | [source](https://erebine.ai/docs/api-reference), [source](https://erebine.ai/docs/authentication), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_management_semantic_router_rules` | GET | `/{project_id}/v1/management/semantic-router/rules` | router | [source](https://erebine.ai/docs/api-reference), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_management_tiers` | GET | `/{project_id}/v1/management/tiers` | router | [source](https://erebine.ai/docs/private-agents), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_mcp` | GET | `/{project_id}/v1/mcp` | router | [source](https://erebine.ai/docs/mcp), [source](https://modelcontextprotocol.io/specification/2025-06-18/basic/transports) |
| `get_project_id_v1_mockups_id_path` | GET | `/{project_id}/v1/mockups/{id}/{path}` | router | [source](https://erebine.ai/docs/server-tools), [source](https://erebine.ai/docs/streaming) |
| `get_project_id_v1_models` | GET | `/{project_id}/v1/models` | router | [source](https://erebine.ai/docs/api-reference), [source](https://erebine.ai/docs/authentication), [source](https://erebine.ai/docs/eem/error-codes), [source](https://erebine.ai/docs/model-management), [source](https://erebine.ai/docs/model-sharing), [source](https://erebine.ai/docs/rerank), [source](https://erebine.ai/docs/systemone), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_models_id` | GET | `/{project_id}/v1/models/{id}` | router | [source](https://erebine.ai/docs/api-reference), [source](https://erebine.ai/docs/model-management), [source](https://erebine.ai/docs/model-sharing), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_models_id_catalog_info` | GET | `/{project_id}/v1/models/{id}/catalog-info` | router | [source](https://erebine.ai/docs/model-management), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_models_id_hf_overrides` | GET | `/{project_id}/v1/models/{id}/hf-overrides` | router | [source](https://erebine.ai/docs/model-management), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_models_id_versions` | GET | `/{project_id}/v1/models/{id}/versions` | router | [source](https://erebine.ai/docs/model-management), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_project_members_search` | GET | `/{project_id}/v1/project-members/search` | router | [source](https://erebine.ai/docs/teams), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_settings_project` | GET | `/{project_id}/v1/settings/project` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_slos` | GET | `/{project_id}/v1/slos` | router | [source](https://erebine.ai/docs/slo-tracking), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_slos_id` | GET | `/{project_id}/v1/slos/{id}` | router | [source](https://erebine.ai/docs/slo-tracking), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_slos_id_history` | GET | `/{project_id}/v1/slos/{id}/history` | router | [source](https://erebine.ai/docs/slo-tracking), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_slos_summary` | GET | `/{project_id}/v1/slos/summary` | router | [source](https://erebine.ai/docs/slo-tracking), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_uploads` | GET | `/{project_id}/v1/uploads` | router | [source](https://erebine.ai/docs/erectl/uploads), [source](https://erebine.ai/docs/uploads), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_uploads_id` | GET | `/{project_id}/v1/uploads/{id}` | router | [source](https://erebine.ai/docs/uploads), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_usage_endpoints` | GET | `/{project_id}/v1/usage/endpoints` | router | [source](https://erebine.ai/docs/usage-billing), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_usage_events` | GET | `/{project_id}/v1/usage/events` | router | [source](https://erebine.ai/docs/usage-billing), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_usage_logs` | GET | `/{project_id}/v1/usage/logs` | router | [source](https://erebine.ai/docs/usage-billing), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_usage_uptime` | GET | `/{project_id}/v1/usage/uptime` | router | [source](https://erebine.ai/docs/usage-billing), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_user_preferences` | GET | `/{project_id}/v1/user/preferences` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_webhooks` | GET | `/{project_id}/v1/webhooks` | router | [source](https://erebine.ai/docs/webhooks), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_webhooks_id` | GET | `/{project_id}/v1/webhooks/{id}` | router | [source](https://erebine.ai/docs/webhooks), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_webhooks_id_deliveries` | GET | `/{project_id}/v1/webhooks/{id}/deliveries` | router | [source](https://erebine.ai/docs/eem/webhooks), [source](https://erebine.ai/docs/webhooks), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_workspaces` | GET | `/{project_id}/v1/workspaces` | router | [source](https://erebine.ai/docs/document-workspace), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_workspaces_id` | GET | `/{project_id}/v1/workspaces/{id}` | router | [source](https://erebine.ai/docs/queueing), [source](https://erebine.ai/docs/zero-data-retention), [source](https://erebine.ai/docs/document-workspace), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_workspaces_id_1_files_id_2` | GET | `/{project_id}/v1/workspaces/{id_1}/files/{id_2}` | router | [source](https://erebine.ai/docs/document-workspace) |
| `get_project_id_v1_workspaces_id_agents` | GET | `/{project_id}/v1/workspaces/{id}/agents` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_workspaces_id_auto_approvals` | GET | `/{project_id}/v1/workspaces/{id}/auto-approvals` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_workspaces_id_chat_templates` | GET | `/{project_id}/v1/workspaces/{id}/chat-templates` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_workspaces_id_decisions` | GET | `/{project_id}/v1/workspaces/{id}/decisions` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_workspaces_id_files` | GET | `/{project_id}/v1/workspaces/{id}/files` | router | [source](https://erebine.ai/docs/document-workspace), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_workspaces_id_graph` | GET | `/{project_id}/v1/workspaces/{id}/graph` | router | [source](https://erebine.ai/docs/workspace-graph) |
| `get_project_id_v1_workspaces_id_members` | GET | `/{project_id}/v1/workspaces/{id}/members` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_workspaces_id_memories` | GET | `/{project_id}/v1/workspaces/{id}/memories` | router | [source](https://erebine.ai/docs/chat-memory), [source](https://erebine.ai/docs/document-workspace), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_v1_workspaces_id_milestones` | GET | `/{project_id}/v1/workspaces/{id}/milestones` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `get_project_id_workspace_id_direct_v1_models` | GET | `/{project_id}/{workspace_id}/_direct/v1/models` | router | [source](https://erebine.ai/docs/direct), [source](https://erebine.ai/docs/opencode), [source](https://erebine.ai/docs/sdk-integrations), [source](https://erebine.ai/docs/vscode) |
| `get_project_id_workspace_id_direct_v1_models_id` | GET | `/{project_id}/{workspace_id}/_direct/v1/models/{id}` | router | [source](https://erebine.ai/docs/direct) |
| `get_project_id_workspace_id_direct_v1_provider_manifest` | GET | `/{project_id}/{workspace_id}/_direct/v1/provider-manifest` | router | [source](https://erebine.ai/docs/direct) |
| `get_project_id_workspace_id_direct_v1_responses` | GET | `/{project_id}/{workspace_id}/_direct/v1/responses` | router | [source](https://erebine.ai/docs/direct) |
| `get_project_id_workspace_id_direct_v1_responses_id` | GET | `/{project_id}/{workspace_id}/_direct/v1/responses/{id}` | router | [source](https://erebine.ai/docs/direct) |
| `get_project_id_workspace_id_direct_v1_responses_id_input_items` | GET | `/{project_id}/{workspace_id}/_direct/v1/responses/{id}/input_items` | router | [source](https://erebine.ai/docs/direct) |
| `get_usage_export_uptime` | GET | `/usage/export/uptime` | dashboard | [source](https://erebine.ai/docs/usage-billing) |
| `options_project_id_endpoint_slug_v1_chat_completions` | OPTIONS | `/{project_id}/{endpoint_slug}/v1/chat/completions` | router | [source](https://erebine.ai/docs/endpoint-cors) |
| `patch_chat_api_id_1_memories_id_2` | PATCH | `/chat/api/{id_1}/memories/{id_2}` | dashboard | [source](https://erebine.ai/docs/chat-memory) |
| `patch_chat_api_workspaces_id` | PATCH | `/chat/api/workspaces/{id}` | dashboard | [source](https://erebine.ai/docs/document-workspace) |
| `patch_chat_api_workspaces_id_1_decisions_id_2` | PATCH | `/chat/api/workspaces/{id_1}/decisions/{id_2}` | dashboard | [source](https://erebine.ai/docs/document-workspace) |
| `patch_chat_api_workspaces_id_1_memories_id_2` | PATCH | `/chat/api/workspaces/{id_1}/memories/{id_2}` | dashboard | [source](https://erebine.ai/docs/chat-memory), [source](https://erebine.ai/docs/document-workspace) |
| `patch_chat_api_workspaces_id_1_milestones_id_2` | PATCH | `/chat/api/workspaces/{id_1}/milestones/{id_2}` | dashboard | [source](https://erebine.ai/docs/document-workspace) |
| `patch_chat_api_workspaces_id_preferences` | PATCH | `/chat/api/workspaces/{id}/preferences` | dashboard | [source](https://erebine.ai/docs/document-workspace) |
| `patch_chat_api_workspaces_id_visibility` | PATCH | `/chat/api/workspaces/{id}/visibility` | dashboard | [source](https://erebine.ai/docs/document-workspace) |
| `patch_project_id_v1_admin_anchors_id` | PATCH | `/{project_id}/v1/admin/anchors/{id}` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `patch_project_id_v1_admin_maintenance_windows_id` | PATCH | `/{project_id}/v1/admin/maintenance/windows/{id}` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `patch_project_id_v1_admin_storage_tiers_id` | PATCH | `/{project_id}/v1/admin/storage-tiers/{id}` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `patch_project_id_v1_chat_templates_id` | PATCH | `/{project_id}/v1/chat-templates/{id}` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `patch_project_id_v1_chats_id` | PATCH | `/{project_id}/v1/chats/{id}` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `patch_project_id_v1_chats_id_1_artifacts_id_2` | PATCH | `/{project_id}/v1/chats/{id_1}/artifacts/{id_2}` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `patch_project_id_v1_chats_id_visibility` | PATCH | `/{project_id}/v1/chats/{id}/visibility` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `patch_project_id_v1_management_agents_id` | PATCH | `/{project_id}/v1/management/agents/{id}` | router | [source](https://erebine.ai/docs/private-agents), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `patch_project_id_v1_management_endpoints_id` | PATCH | `/{project_id}/v1/management/endpoints/{id}` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `patch_project_id_v1_management_endpoints_id_1_agents_id_2` | PATCH | `/{project_id}/v1/management/endpoints/{id_1}/agents/{id_2}` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `patch_project_id_v1_management_maintenance_id` | PATCH | `/{project_id}/v1/management/maintenance/{id}` | router | [source](https://erebine.ai/docs/status-maintenance), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `patch_project_id_v1_management_project_members_id` | PATCH | `/{project_id}/v1/management/project/members/{id}` | router | [source](https://erebine.ai/docs/teams), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `patch_project_id_v1_management_semantic_router_config` | PATCH | `/{project_id}/v1/management/semantic-router/config` | router | [source](https://erebine.ai/docs/api-reference), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `patch_project_id_v1_management_semantic_router_rules_id` | PATCH | `/{project_id}/v1/management/semantic-router/rules/{id}` | router | [source](https://erebine.ai/docs/api-reference), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `patch_project_id_v1_models_id` | PATCH | `/{project_id}/v1/models/{id}` | router | [source](https://erebine.ai/docs/eim/advanced), [source](https://erebine.ai/docs/erectl/models), [source](https://erebine.ai/docs/model-management), [source](https://erebine.ai/docs/model-upload), [source](https://erebine.ai/docs/private-agents), [source](https://erebine.ai/docs/systemone), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `patch_project_id_v1_settings_project` | PATCH | `/{project_id}/v1/settings/project` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `patch_project_id_v1_user_preferences` | PATCH | `/{project_id}/v1/user/preferences` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `patch_project_id_v1_workspaces_id` | PATCH | `/{project_id}/v1/workspaces/{id}` | router | [source](https://erebine.ai/docs/document-workspace), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `patch_project_id_v1_workspaces_id_1_chat_templates_id_2` | PATCH | `/{project_id}/v1/workspaces/{id_1}/chat-templates/{id_2}` | router | [source](https://erebine.ai/docs/erectl/templates) |
| `patch_project_id_v1_workspaces_id_1_decisions_id_2` | PATCH | `/{project_id}/v1/workspaces/{id_1}/decisions/{id_2}` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `patch_project_id_v1_workspaces_id_1_memories_id_2` | PATCH | `/{project_id}/v1/workspaces/{id_1}/memories/{id_2}` | router | [source](https://erebine.ai/docs/chat-memory), [source](https://erebine.ai/docs/document-workspace), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `patch_project_id_v1_workspaces_id_1_milestones_id_2` | PATCH | `/{project_id}/v1/workspaces/{id_1}/milestones/{id_2}` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `patch_project_id_v1_workspaces_id_visibility` | PATCH | `/{project_id}/v1/workspaces/{id}/visibility` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_account_api_invite` | POST | `/account/api/invite` | dashboard | [source](https://erebine.ai/docs/teams) |
| `post_agents_id_disable` | POST | `/agents/{id}/disable` | dashboard | [source](https://erebine.ai/docs/private-agents) |
| `post_agents_id_enable` | POST | `/agents/{id}/enable` | dashboard | [source](https://erebine.ai/docs/private-agents) |
| `post_agents_id_reset` | POST | `/agents/{id}/reset` | dashboard | [source](https://erebine.ai/docs/private-agents) |
| `post_billing_budgets` | POST | `/billing/budgets` | dashboard | [source](https://erebine.ai/docs/budget-alerts) |
| `post_billing_budgets_check` | POST | `/billing/budgets/check` | dashboard | [source](https://erebine.ai/docs/budget-alerts) |
| `post_billing_cancel` | POST | `/billing/cancel` | dashboard | [source](https://erebine.ai/docs/billing-subscriptions) |
| `post_billing_checkout` | POST | `/billing/checkout` | dashboard | [source](https://erebine.ai/docs/billing-subscriptions) |
| `post_billing_credits` | POST | `/billing/credits` | dashboard | [source](https://erebine.ai/docs/billing-subscriptions) |
| `post_billing_portal` | POST | `/billing/portal` | dashboard | [source](https://erebine.ai/docs/billing-subscriptions) |
| `post_billing_reactivate` | POST | `/billing/reactivate` | dashboard | [source](https://erebine.ai/docs/billing-subscriptions) |
| `post_chat_api_id_1_memories_id_2_rerun_extraction` | POST | `/chat/api/{id_1}/memories/{id_2}/rerun-extraction` | dashboard | [source](https://erebine.ai/docs/chat-memory) |
| `post_chat_api_id_branch` | POST | `/chat/api/{id}/branch` | dashboard | [source](https://erebine.ai/docs/chat-branching) |
| `post_chat_api_id_memory` | POST | `/chat/api/{id}/memory` | dashboard | [source](https://erebine.ai/docs/chat-memory) |
| `post_chat_api_workspaces` | POST | `/chat/api/workspaces` | dashboard | [source](https://erebine.ai/docs/document-workspace) |
| `post_chat_api_workspaces_id_files` | POST | `/chat/api/workspaces/{id}/files` | dashboard | [source](https://erebine.ai/docs/document-workspace) |
| `post_chat_api_workspaces_id_members` | POST | `/chat/api/workspaces/{id}/members` | dashboard | [source](https://erebine.ai/docs/document-workspace) |
| `post_chat_api_workspaces_id_memories` | POST | `/chat/api/workspaces/{id}/memories` | dashboard | [source](https://erebine.ai/docs/chat-memory), [source](https://erebine.ai/docs/document-workspace) |
| `post_chat_api_workspaces_id_revalidate_embeddings` | POST | `/chat/api/workspaces/{id}/revalidate-embeddings` | dashboard | [source](https://erebine.ai/docs/document-workspace) |
| `post_chat_api_workspaces_id_revalidate_memories` | POST | `/chat/api/workspaces/{id}/revalidate-memories` | dashboard | [source](https://erebine.ai/docs/document-workspace) |
| `post_chat_api_workspaces_id_search` | POST | `/chat/api/workspaces/{id}/search` | dashboard | [source](https://erebine.ai/docs/document-workspace) |
| `post_chat_api_workspaces_id_upload` | POST | `/chat/api/workspaces/{id}/upload` | dashboard | [source](https://erebine.ai/docs/document-workspace) |
| `post_gdpr_delete` | POST | `/gdpr/delete` | dashboard | [source](https://erebine.ai/docs/data-export) |
| `post_gdpr_delete_id_cancel` | POST | `/gdpr/delete/{id}/cancel` | dashboard | [source](https://erebine.ai/docs/data-export) |
| `post_gdpr_delete_id_confirm` | POST | `/gdpr/delete/{id}/confirm` | dashboard | [source](https://erebine.ai/docs/data-export) |
| `post_gdpr_export` | POST | `/gdpr/export` | dashboard | [source](https://erebine.ai/docs/data-export) |
| `post_gdpr_export_id_cancel` | POST | `/gdpr/export/{id}/cancel` | dashboard | [source](https://erebine.ai/docs/data-export) |
| `post_project_id_endpoint_slug_v1_audio_speech` | POST | `/{project_id}/{endpoint_slug}/v1/audio/speech` | router | [source](https://erebine.ai/docs/api-reference), [source](https://erebine.ai/docs/audio) |
| `post_project_id_endpoint_slug_v1_audio_transcriptions` | POST | `/{project_id}/{endpoint_slug}/v1/audio/transcriptions` | router | [source](https://erebine.ai/docs/api-reference), [source](https://erebine.ai/docs/audio) |
| `post_project_id_endpoint_slug_v1_audio_translations` | POST | `/{project_id}/{endpoint_slug}/v1/audio/translations` | router | [source](https://erebine.ai/docs/api-reference), [source](https://erebine.ai/docs/audio) |
| `post_project_id_endpoint_slug_v1_batches` | POST | `/{project_id}/{endpoint_slug}/v1/batches` | router | [source](https://erebine.ai/docs/batch) |
| `post_project_id_endpoint_slug_v1_chat_completions` | POST | `/{project_id}/{endpoint_slug}/v1/chat/completions` | router | [source](https://erebine.ai/docs/api-reference), [source](https://erebine.ai/docs/audio), [source](https://erebine.ai/docs/slo-tracking), [source](https://erebine.ai/docs/streaming), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_endpoint_slug_v1_chat_completions_id` | POST | `/{project_id}/{endpoint_slug}/v1/chat/completions/{id}` | router | [source](https://erebine.ai/docs/completions), [source](https://erebine.ai/docs/sdk-integrations), [source](https://erebine.ai/docs/tool-calling), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_endpoint_slug_v1_embeddings` | POST | `/{project_id}/{endpoint_slug}/v1/embeddings` | router | [source](https://erebine.ai/docs/embeddings), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_endpoint_slug_v1_rerank` | POST | `/{project_id}/{endpoint_slug}/v1/rerank` | router | [source](https://erebine.ai/docs/rerank), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_endpoint_slug_v1_responses` | POST | `/{project_id}/{endpoint_slug}/v1/responses` | router | [source](https://erebine.ai/docs/conversations), [source](https://erebine.ai/docs/responses), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_endpoint_slug_v1_responses_id_cancel` | POST | `/{project_id}/{endpoint_slug}/v1/responses/{id}/cancel` | router | [source](https://erebine.ai/docs/responses), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_endpoint_slug_v1_score` | POST | `/{project_id}/{endpoint_slug}/v1/score` | router | [source](https://erebine.ai/docs/rerank), [source](https://erebine.ai/docs/sdk-integrations) |
| `post_project_id_endpoint_slug_v1_systemone` | POST | `/{project_id}/{endpoint_slug}/v1/systemone` | router | [source](https://erebine.ai/docs/api-reference), [source](https://erebine.ai/docs/systemone) |
| `post_project_id_semantic_router_v1_chat_completions` | POST | `/{project_id}/_semantic/router/v1/chat/completions` | router | [source](https://erebine.ai/docs/api-reference) |
| `post_project_id_semantic_router_v1_chat_completions_multimodel` | POST | `/{project_id}/_semantic/router/v1/chat/completions/multimodel` | router | [source](https://erebine.ai/docs/api-reference) |
| `post_project_id_v1_admin_cache_clear` | POST | `/{project_id}/v1/admin/cache/clear` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_admin_maintenance_windows` | POST | `/{project_id}/v1/admin/maintenance/windows` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_admin_private_agents_id_attach_project` | POST | `/{project_id}/v1/admin/private-agents/{id}/attach-project` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_admin_storage_tiers` | POST | `/{project_id}/v1/admin/storage-tiers` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_admin_tasks_id_cancel` | POST | `/{project_id}/v1/admin/tasks/{id}/cancel` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_batches` | POST | `/{project_id}/v1/batches` | router | [source](https://erebine.ai/docs/batch) |
| `post_project_id_v1_batches_id_cancel` | POST | `/{project_id}/v1/batches/{id}/cancel` | router | [source](https://erebine.ai/docs/batch), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_chat_templates` | POST | `/{project_id}/v1/chat-templates` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_chat_templates_id_promote` | POST | `/{project_id}/v1/chat-templates/{id}/promote` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_chats` | POST | `/{project_id}/v1/chats` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_chats_id_auto_fork` | POST | `/{project_id}/v1/chats/{id}/auto_fork` | router | [source](https://erebine.ai/docs/chat-branching) |
| `post_project_id_v1_chats_id_branches` | POST | `/{project_id}/v1/chats/{id}/branches` | router | [source](https://erebine.ai/docs/chat-branching), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_conversations` | POST | `/{project_id}/v1/conversations` | router | [source](https://erebine.ai/docs/conversations), [source](https://erebine.ai/docs/erectl/conversations), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_conversations_id` | POST | `/{project_id}/v1/conversations/{id}` | router | [source](https://erebine.ai/docs/conversations), [source](https://erebine.ai/docs/erectl/conversations), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_conversations_id_items` | POST | `/{project_id}/v1/conversations/{id}/items` | router | [source](https://erebine.ai/docs/api-reference), [source](https://erebine.ai/docs/conversations), [source](https://erebine.ai/docs/erectl/conversations), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_exec_approvals_id_approve` | POST | `/{project_id}/v1/exec/approvals/{id}/approve` | router | [source](https://erebine.ai/docs/eem/approvals), [source](https://erebine.ai/docs/eem/tutorials), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_exec_approvals_id_reject` | POST | `/{project_id}/v1/exec/approvals/{id}/reject` | router | [source](https://erebine.ai/docs/eem/approvals), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_exec_invocations` | POST | `/{project_id}/v1/exec/invocations` | router | [source](https://erebine.ai/docs/eem), [source](https://erebine.ai/docs/eem/glossary), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_exec_invocations_id_cancel` | POST | `/{project_id}/v1/exec/invocations/{id}/cancel` | router | [source](https://erebine.ai/docs/eem/approvals), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_exports_executions` | POST | `/{project_id}/v1/exports/executions` | router | [source](https://erebine.ai/docs/data-export) |
| `post_project_id_v1_exports_logs` | POST | `/{project_id}/v1/exports/logs` | router | [source](https://erebine.ai/docs/data-export), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_exports_metrics` | POST | `/{project_id}/v1/exports/metrics` | router | [source](https://erebine.ai/docs/data-export) |
| `post_project_id_v1_exports_usage` | POST | `/{project_id}/v1/exports/usage` | router | [source](https://erebine.ai/docs/data-export) |
| `post_project_id_v1_files` | POST | `/{project_id}/v1/files` | router | [source](https://erebine.ai/docs/api-reference), [source](https://erebine.ai/docs/files), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_internal_research` | POST | `/{project_id}/v1/internal/research` | router | [source](https://erebine.ai/docs/eem) |
| `post_project_id_v1_management_agents` | POST | `/{project_id}/v1/management/agents` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_management_agents_id_curve_rotate` | POST | `/{project_id}/v1/management/agents/{id}/curve-rotate` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_management_api_keys` | POST | `/{project_id}/v1/management/api-keys` | router | [source](https://erebine.ai/docs/authentication), [source](https://erebine.ai/docs/erectl/keys), [source](https://erebine.ai/docs/sdk-integrations), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_management_api_keys_id_rotate` | POST | `/{project_id}/v1/management/api-keys/{id}/rotate` | router | [source](https://erebine.ai/docs/erectl/keys), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_management_endpoints` | POST | `/{project_id}/v1/management/endpoints` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_management_endpoints_id_agents` | POST | `/{project_id}/v1/management/endpoints/{id}/agents` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_management_endpoints_id_provision` | POST | `/{project_id}/v1/management/endpoints/{id}/provision` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_management_endpoints_id_regenerate_capabilities` | POST | `/{project_id}/v1/management/endpoints/{id}/regenerate-capabilities` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_management_endpoints_id_unprovision` | POST | `/{project_id}/v1/management/endpoints/{id}/unprovision` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_management_evolution_id_lane_breaker_reset` | POST | `/{project_id}/v1/management/evolution/{id}/{lane}/breaker/reset` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_management_evolution_id_lane_rollback` | POST | `/{project_id}/v1/management/evolution/{id}/{lane}/rollback` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_management_evolution_id_lane_run` | POST | `/{project_id}/v1/management/evolution/{id}/{lane}/run` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_management_join_keys` | POST | `/{project_id}/v1/management/join-keys` | router | [source](https://erebine.ai/docs/private-agents), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_management_maintenance` | POST | `/{project_id}/v1/management/maintenance` | router | [source](https://erebine.ai/docs/status-maintenance), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_management_maintenance_id_complete` | POST | `/{project_id}/v1/management/maintenance/{id}/complete` | router | [source](https://erebine.ai/docs/status-maintenance), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_management_maintenance_id_purge` | POST | `/{project_id}/v1/management/maintenance/{id}/purge` | router | [source](https://erebine.ai/docs/status-maintenance), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_management_project_invitations_id_resend` | POST | `/{project_id}/v1/management/project/invitations/{id}/resend` | router | [source](https://erebine.ai/docs/teams), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_management_project_members` | POST | `/{project_id}/v1/management/project/members` | router | [source](https://erebine.ai/docs/teams), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_management_semantic_router_rules` | POST | `/{project_id}/v1/management/semantic-router/rules` | router | [source](https://erebine.ai/docs/api-reference), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_mcp` | POST | `/{project_id}/v1/mcp` | router | [source](https://erebine.ai/docs/mcp), [source](https://modelcontextprotocol.io/specification/2025-06-18/basic/transports) |
| `post_project_id_v1_models_id_hf_overrides_preview` | POST | `/{project_id}/v1/models/{id}/hf-overrides/preview` | router | [source](https://erebine.ai/docs/model-management) |
| `post_project_id_v1_models_id_revalidate` | POST | `/{project_id}/v1/models/{id}/revalidate` | router | [source](https://erebine.ai/docs/model-management), [source](https://erebine.ai/docs/model-versioning), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_models_id_share` | POST | `/{project_id}/v1/models/{id}/share` | router | [source](https://erebine.ai/docs/model-management), [source](https://erebine.ai/docs/model-sharing), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_models_id_unshare` | POST | `/{project_id}/v1/models/{id}/unshare` | router | [source](https://erebine.ai/docs/model-management), [source](https://erebine.ai/docs/model-sharing), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_models_id_versions` | POST | `/{project_id}/v1/models/{id}/versions` | router | [source](https://erebine.ai/docs/model-management), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_models_id_versions_1_0_0_promote` | POST | `/{project_id}/v1/models/{id}/versions/1.0.0/promote` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_models_id_versions_1_0_0_rollback` | POST | `/{project_id}/v1/models/{id}/versions/1.0.0/rollback` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_models_id_versions_version_promote` | POST | `/{project_id}/v1/models/{id}/versions/{version}/promote` | router | [source](https://erebine.ai/docs/model-management) |
| `post_project_id_v1_models_id_versions_version_rollback` | POST | `/{project_id}/v1/models/{id}/versions/{version}/rollback` | router | [source](https://erebine.ai/docs/model-management) |
| `post_project_id_v1_slos` | POST | `/{project_id}/v1/slos` | router | [source](https://erebine.ai/docs/erectl/slos), [source](https://erebine.ai/docs/slo-tracking) |
| `post_project_id_v1_slos_id_calculate` | POST | `/{project_id}/v1/slos/{id}/calculate` | router | [source](https://erebine.ai/docs/slo-tracking), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_uploads` | POST | `/{project_id}/v1/uploads` | router | [source](https://erebine.ai/docs/uploads) |
| `post_project_id_v1_uploads_archive` | POST | `/{project_id}/v1/uploads/archive` | router | [source](https://erebine.ai/docs/model-upload), [source](https://erebine.ai/docs/uploads), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_uploads_directory` | POST | `/{project_id}/v1/uploads/directory` | router | [source](https://erebine.ai/docs/model-upload), [source](https://erebine.ai/docs/uploads), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_uploads_id_cancel` | POST | `/{project_id}/v1/uploads/{id}/cancel` | router | [source](https://erebine.ai/docs/uploads), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_uploads_id_complete` | POST | `/{project_id}/v1/uploads/{id}/complete` | router | [source](https://erebine.ai/docs/model-upload), [source](https://erebine.ai/docs/uploads), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_uploads_id_file_chunks_chunk_index` | POST | `/{project_id}/v1/uploads/{id}/file-chunks/{chunk_index}` | router | [source](https://erebine.ai/docs/model-upload), [source](https://erebine.ai/docs/uploads) |
| `post_project_id_v1_uploads_id_file_complete` | POST | `/{project_id}/v1/uploads/{id}/file-complete` | router | [source](https://erebine.ai/docs/model-upload), [source](https://erebine.ai/docs/uploads) |
| `post_project_id_v1_uploads_id_files_relative_path` | POST | `/{project_id}/v1/uploads/{id}/files/{relative_path}` | router | [source](https://erebine.ai/docs/model-upload), [source](https://erebine.ai/docs/uploads), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_uploads_id_parts` | POST | `/{project_id}/v1/uploads/{id}/parts` | router | [source](https://erebine.ai/docs/model-upload), [source](https://erebine.ai/docs/uploads), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_uploads_id_resume` | POST | `/{project_id}/v1/uploads/{id}/resume` | router | [source](https://erebine.ai/docs/model-upload), [source](https://erebine.ai/docs/uploads), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_uploads_preflight` | POST | `/{project_id}/v1/uploads/preflight` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_webhooks` | POST | `/{project_id}/v1/webhooks` | router | [source](https://erebine.ai/docs/eem/webhooks), [source](https://erebine.ai/docs/webhooks), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_webhooks_id_test` | POST | `/{project_id}/v1/webhooks/{id}/test` | router | [source](https://erebine.ai/docs/webhooks), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_workspaces` | POST | `/{project_id}/v1/workspaces` | router | [source](https://erebine.ai/docs/document-workspace), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_workspaces_id_1_agents_id_2_pause` | POST | `/{project_id}/v1/workspaces/{id_1}/agents/{id_2}/pause` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_workspaces_id_1_agents_id_2_resume` | POST | `/{project_id}/v1/workspaces/{id_1}/agents/{id_2}/resume` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_workspaces_id_1_chat_templates_id_2_apply` | POST | `/{project_id}/v1/workspaces/{id_1}/chat-templates/{id_2}/apply` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_workspaces_id_agents` | POST | `/{project_id}/v1/workspaces/{id}/agents` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_workspaces_id_auto_approvals` | POST | `/{project_id}/v1/workspaces/{id}/auto-approvals` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_workspaces_id_chat_templates` | POST | `/{project_id}/v1/workspaces/{id}/chat-templates` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_workspaces_id_files` | POST | `/{project_id}/v1/workspaces/{id}/files` | router | [source](https://erebine.ai/docs/document-workspace) |
| `post_project_id_v1_workspaces_id_memories` | POST | `/{project_id}/v1/workspaces/{id}/memories` | router | [source](https://erebine.ai/docs/chat-memory), [source](https://erebine.ai/docs/document-workspace), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_workspaces_id_revalidate_intelligence` | POST | `/{project_id}/v1/workspaces/{id}/revalidate-intelligence` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_v1_workspaces_id_search` | POST | `/{project_id}/v1/workspaces/{id}/search` | router | [source](https://erebine.ai/docs/document-workspace), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `post_project_id_workspace_id_direct_v1_audio_speech` | POST | `/{project_id}/{workspace_id}/_direct/v1/audio/speech` | router | [source](https://erebine.ai/docs/direct) |
| `post_project_id_workspace_id_direct_v1_audio_transcriptions` | POST | `/{project_id}/{workspace_id}/_direct/v1/audio/transcriptions` | router | [source](https://erebine.ai/docs/direct) |
| `post_project_id_workspace_id_direct_v1_audio_translations` | POST | `/{project_id}/{workspace_id}/_direct/v1/audio/translations` | router | [source](https://erebine.ai/docs/direct) |
| `post_project_id_workspace_id_direct_v1_chat_completions` | POST | `/{project_id}/{workspace_id}/_direct/v1/chat/completions` | router | [source](https://erebine.ai/docs/direct) |
| `post_project_id_workspace_id_direct_v1_embeddings` | POST | `/{project_id}/{workspace_id}/_direct/v1/embeddings` | router | [source](https://erebine.ai/docs/direct) |
| `post_project_id_workspace_id_direct_v1_rerank` | POST | `/{project_id}/{workspace_id}/_direct/v1/rerank` | router | [source](https://erebine.ai/docs/direct) |
| `post_project_id_workspace_id_direct_v1_responses` | POST | `/{project_id}/{workspace_id}/_direct/v1/responses` | router | [source](https://erebine.ai/docs/direct) |
| `post_project_id_workspace_id_direct_v1_responses_id_cancel` | POST | `/{project_id}/{workspace_id}/_direct/v1/responses/{id}/cancel` | router | [source](https://erebine.ai/docs/direct) |
| `post_project_id_workspace_id_direct_v1_score` | POST | `/{project_id}/{workspace_id}/_direct/v1/score` | router | [source](https://erebine.ai/docs/direct) |
| `post_project_id_workspace_id_direct_v1_systemone` | POST | `/{project_id}/{workspace_id}/_direct/v1/systemone` | router | [source](https://erebine.ai/docs/api-reference), [source](https://erebine.ai/docs/direct), [source](https://erebine.ai/docs/systemone) |
| `post_projects_members` | POST | `/projects/members` | dashboard | [source](https://erebine.ai/docs/teams) |
| `post_v1_enroll` | POST | `/v1/enroll` | router | [source](https://erebine.ai/docs/eem/architecture), [source](https://erebine.ai/docs/eem/error-codes), [source](https://erebine.ai/docs/eem/troubleshooting), [source](https://erebine.ai/docs/eim) |
| `post_v1_enroll_refresh` | POST | `/v1/enroll/refresh` | router | [source](https://erebine.ai/docs/eem/architecture) |
| `put_billing_budgets_id` | PUT | `/billing/budgets/{id}` | dashboard | [source](https://erebine.ai/docs/budget-alerts) |
| `put_project_id_v1_chats_id_exec_workspace` | PUT | `/{project_id}/v1/chats/{id}/exec-workspace` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `put_project_id_v1_management_api_keys_id_ip_filter` | PUT | `/{project_id}/v1/management/api-keys/{id}/ip-filter` | router | [source](https://erebine.ai/docs/erectl/keys), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `put_project_id_v1_management_api_keys_id_quota` | PUT | `/{project_id}/v1/management/api-keys/{id}/quota` | router | [source](https://erebine.ai/docs/erectl/keys), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `put_project_id_v1_management_endpoints_id_cors` | PUT | `/{project_id}/v1/management/endpoints/{id}/cors` | router | [source](https://erebine.ai/docs/endpoint-cors), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `put_project_id_v1_management_endpoints_id_health_config` | PUT | `/{project_id}/v1/management/endpoints/{id}/health/config` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `put_project_id_v1_management_evolution_id_lane_enable` | PUT | `/{project_id}/v1/management/evolution/{id}/{lane}/enable` | router | [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |
| `put_project_id_v1_slos_id` | PUT | `/{project_id}/v1/slos/{id}` | router | [source](https://erebine.ai/docs/slo-tracking) |
| `put_project_id_v1_webhooks_id` | PUT | `/{project_id}/v1/webhooks/{id}` | router | [source](https://erebine.ai/docs/webhooks), [source](https://github.com/erebine/binaries/releases/tag/v2.7.3) |

Worker validation templates include CORS persistence and workspace-scoped batch
flows. They require a restrictive private loopback fixture controller. Positive
generated-token counts and terminal stream output are required; HTTP 200 or
`status: completed` alone do not pass. See [live validation](../LIVE_VALIDATION.md)
for currently failing service checks. The metadata preflight and local validator
regressions are in `scripts/check_worker_fixture.py` and
`scripts/test_worker_validation.py`.
