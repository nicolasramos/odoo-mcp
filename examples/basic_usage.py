"""
Basic Usage Examples for Odoo MCP Server

This file demonstrates common operations with the Odoo MCP Server.
"""

import os
import json
from typing import Dict, Any


# Example 1: Searching for Partners
def example_search_partners() -> Dict[str, Any]:
    """
    Search for customers using customer_rank > 0 (Odoo 18 compatible)

    NOTE: In Odoo 18, use customer_rank > 0 instead of customer=True
    """
    return {
        "tool": "odoo_search",
        "payload": {
            "model": "res.partner",
            "domain": [
                ["customer_rank", ">", 0],  # Odoo 18 compatible
                ["active", "=", True]
            ],
            "limit": 10
        }
    }


# Example 2: Creating a Sale Order
def example_create_sale_order() -> Dict[str, Any]:
    """
    Create a new sale order with multiple lines
    """
    return {
        "tool": "odoo_create_sale_order",
        "payload": {
            "partner_id": 42,  # Customer ID
            "lines": [
                {
                    "product_id": 15,
                    "product_uom_qty": 2.0,
                    "price_unit": 99.99
                },
                {
                    "product_id": 20,
                    "product_uom_qty": 1.0,
                    "price_unit": 149.50
                }
            ]
        }
    }


# Example 3: Finding Pending Invoices
def example_find_pending_invoices() -> Dict[str, Any]:
    """
    Find pending customer invoices

    NOTE: This tool handles Odoo 18 payment_state automatically
    Uses: state='posted' AND payment_state in ('not_paid', 'partial')
    """
    return {
        "tool": "odoo_find_pending_invoices",
        "payload": {
            "partner_id": 42,
            "move_type": "out_invoice",  # Customer invoices
            "limit": 20
        }
    }


# Example 4: Creating an Activity
def example_create_activity() -> Dict[str, Any]:
    """
    Schedule a follow-up activity for a customer
    """
    return {
        "tool": "odoo_create_activity",
        "payload": {
            "model": "res.partner",
            "res_id": 42,
            "summary": "Follow up on quote",
            "note": "Customer requested a call next week",
            "user_id": 5  # Assign to specific user
        }
    }


# Example 5: Getting Partner Summary
def example_get_partner_summary() -> Dict[str, Any]:
    """
    Get comprehensive partner information including related documents
    """
    return {
        "tool": "odoo_get_partner_summary",
        "payload": {
            "partner_id": 42
        }
    }


# Example 6: Creating a Project Task
def example_create_task() -> Dict[str, Any]:
    """
    Create a new project task with assignment and deadline
    """
    return {
        "tool": "odoo_create_task",
        "payload": {
            "name": "Implement customer feedback",
            "project_id": 3,
            "description": "Address issues raised in customer meeting",
            "assigned_to": 8,
            "deadline": "2024-12-31"
        }
    }


# Example 7: Logging Timesheet
def example_log_timesheet() -> Dict[str, Any]:
    """
    Log work time on a project task
    """
    return {
        "tool": "odoo_log_timesheet",
        "payload": {
            "project_id": 3,
            "task_id": 15,
            "name": "Completed customer requirements analysis",
            "unit_amount": 2.5,  # Hours
            "date": "2024-01-15"
        }
    }


# Example 8: Registering Payment
def example_register_payment() -> Dict[str, Any]:
    """
    Register a payment for an invoice
    """
    return {
        "tool": "odoo_register_payment",
        "payload": {
            "invoice_id": 123,
            "amount": 1500.00,
            "payment_date": "2024-01-15",
            "journal_id": 7  # Bank journal
        }
    }


# Example 9: Creating a Calendar Event
def example_create_calendar_event() -> Dict[str, Any]:
    """
    Schedule a meeting with multiple attendees
    """
    return {
        "tool": "odoo_create_calendar_event",
        "payload": {
            "name": "Quarterly Review Meeting",
            "start": "2024-01-20 10:00:00",
            "stop": "2024-01-20 11:30:00",
            "partner_ids": [42, 45, 48],  # Attendees
            "description": "Q1 2024 performance review",
            "allday": False
        }
    }


# Example 10: Introspecting Model Schema
def example_get_model_schema() -> Dict[str, Any]:
    """
    Get field definitions for a model
    Useful when you're unsure about available fields
    """
    return {
        "tool": "odoo_get_model_schema",
        "payload": {
            "model": "sale.order"
        }
    }


def main() -> None:
    """
    Run all examples and print their payloads
    """
    examples = [
        ("Search Partners", example_search_partners()),
        ("Create Sale Order", example_create_sale_order()),
        ("Find Pending Invoices", example_find_pending_invoices()),
        ("Create Activity", example_create_activity()),
        ("Get Partner Summary", example_get_partner_summary()),
        ("Create Task", example_create_task()),
        ("Log Timesheet", example_log_timesheet()),
        ("Register Payment", example_register_payment()),
        ("Create Calendar Event", example_create_calendar_event()),
        ("Get Model Schema", example_get_model_schema()),
    ]

    print("=" * 80)
    print("Odoo MCP Server - Basic Usage Examples")
    print("=" * 80)
    print()

    for title, example in examples:
        print(f"\n{'─' * 80}")
        print(f"Example: {title}")
        print(f"{'─' * 80}")
        print(f"Tool: {example['tool']}")
        print(f"Payload:")
        print(json.dumps(example['payload'], indent=2))

    print("\n" + "=" * 80)
    print("Note: These are example payloads for MCP tools")
    print("Actual execution depends on your MCP client setup")
    print("=" * 80)


if __name__ == "__main__":
    main()
