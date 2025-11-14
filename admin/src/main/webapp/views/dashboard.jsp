<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid p-4 p-lg-5">
    <!-- Page Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h1 class="h3 mb-0">Dashboard</h1>
            <p class="text-muted mb-0">Welcome back! Here's what's happening.</p>
        </div>
        <div class="d-flex gap-2">
            <button type="button" class="btn btn-primary">
                <i class="bi bi-plus-lg me-2"></i>
                New Item
            </button>
            <button type="button" class="btn btn-outline-secondary" 
                    data-bs-toggle="tooltip" 
                    title="Refresh data">
                <i class="bi bi-arrow-clockwise icon-hover"></i>
            </button>
            <button type="button" class="btn btn-outline-secondary" 
                    data-bs-toggle="tooltip" 
                    title="Export data">
                <i class="bi bi-download icon-hover"></i>
            </button>
            <button type="button" class="btn btn-outline-secondary" 
                    data-bs-toggle="tooltip" 
                    title="Settings">
                <i class="bi bi-gear icon-hover"></i>
            </button>
        </div>
    </div>

    <!-- Stats Cards -->
    <div class="row g-4 mb-4">
        <div class="col-xl-3 col-lg-6">
            <div class="card stats-card">
                <div class="card-body">
                    <div class="d-flex align-items-center">
                        <div class="flex-shrink-0">
                            <div class="stats-icon bg-primary bg-opacity-10 text-primary">
                                <i class="bi bi-people"></i>
                            </div>
                        </div>
                        <div class="flex-grow-1 ms-3">
                            <h6 class="mb-0 text-muted">Total Users</h6>
                            <h3 class="mb-0">12,426</h3>
                            <small class="text-success">
                                <i class="bi bi-arrow-up"></i> +12.5%
                            </small>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-lg-6">
            <div class="card stats-card">
                <div class="card-body">
                    <div class="d-flex align-items-center">
                        <div class="flex-shrink-0">
                            <div class="stats-icon bg-success bg-opacity-10 text-success">
                                <i class="bi bi-graph-up"></i>
                            </div>
                        </div>
                        <div class="flex-grow-1 ms-3">
                            <h6 class="mb-0 text-muted">Revenue</h6>
                            <h3 class="mb-0">$54,320</h3>
                            <small class="text-success">
                                <i class="bi bi-arrow-up"></i> +8.2%
                            </small>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-lg-6">
            <div class="card stats-card">
                <div class="card-body">
                    <div class="d-flex align-items-center">
                        <div class="flex-shrink-0">
                            <div class="stats-icon bg-warning bg-opacity-10 text-warning">
                                <i class="bi bi-bag-check"></i>
                            </div>
                        </div>
                        <div class="flex-grow-1 ms-3">
                            <h6 class="mb-0 text-muted">Orders</h6>
                            <h3 class="mb-0">1,852</h3>
                            <small class="text-danger">
                                <i class="bi bi-arrow-down"></i> -2.1%
                            </small>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-lg-6">
            <div class="card stats-card">
                <div class="card-body">
                    <div class="d-flex align-items-center">
                        <div class="flex-shrink-0">
                            <div class="stats-icon bg-info bg-opacity-10 text-info">
                                <i class="bi bi-clock-history"></i>
                            </div>
                        </div>
                        <div class="flex-grow-1 ms-3">
                            <h6 class="mb-0 text-muted">Avg. Response</h6>
                            <h3 class="mb-0">2.3s</h3>
                            <small class="text-success">
                                <i class="bi bi-arrow-up"></i> +5.4%
                            </small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Chart Section -->
    <div class="row g-4 mb-4">
        <div class="col-lg-8">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="card-title mb-0">Revenue Overview</h5>
                    <div class="btn-group btn-group-sm" role="group">
                        <button type="button" class="btn btn-outline-primary active">7D</button>
                        <button type="button" class="btn btn-outline-primary">30D</button>
                        <button type="button" class="btn btn-outline-primary">90D</button>
                        <button type="button" class="btn btn-outline-primary">1Y</button>
                    </div>
                </div>
                <div class="card-body">
                    <canvas id="revenueChart" height="250"></canvas>
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title mb-0">Recent Activity</h5>
                </div>
                <div class="card-body">
                    <div class="activity-feed">
                        <div class="activity-item">
                            <div class="activity-icon bg-primary bg-opacity-10 text-primary">
                                <i class="bi bi-person-plus"></i>
                            </div>
                            <div class="activity-content">
                                <p class="mb-1">New user registered</p>
                                <small class="text-muted">2 minutes ago</small>
                            </div>
                        </div>
                        <div class="activity-item">
                            <div class="activity-icon bg-success bg-opacity-10 text-success">
                                <i class="bi bi-bag-check"></i>
                            </div>
                            <div class="activity-content">
                                <p class="mb-1">Order #1234 completed</p>
                                <small class="text-muted">5 minutes ago</small>
                            </div>
                        </div>
                        <div class="activity-item">
                            <div class="activity-icon bg-warning bg-opacity-10 text-warning">
                                <i class="bi bi-exclamation-triangle"></i>
                            </div>
                            <div class="activity-content">
                                <p class="mb-1">Server maintenance scheduled</p>
                                <small class="text-muted">1 hour ago</small>
                            </div>
                        </div>
                        <div class="activity-item">
                            <div class="activity-icon bg-danger bg-opacity-10 text-danger">
                                <i class="bi bi-x-circle"></i>
                            </div>
                            <div class="activity-content">
                                <p class="mb-1">Payment failed for order #4321</p>
                                <small class="text-muted">3 hours ago</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Additional Charts Row -->
    <div class="row g-4 mb-4">
        <div class="col-lg-6">
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title mb-0">User Growth (Last 7 Days)</h5>
                </div>
                <div class="card-body">
                    <canvas id="userGrowthChart" height="200"></canvas>
                </div>
            </div>
        </div>

        <div class="col-lg-6">
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title mb-0">Order Status Distribution</h5>
                </div>
                <div class="card-body">
                    <canvas id="orderStatusChart" height="200"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Orders -->
    <div class="row g-4">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title mb-0">Recent Orders</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>Order ID</th>
                                    <th>Customer</th>
                                    <th>Product</th>
                                    <th>Amount</th>
                                    <th>Status</th>
                                    <th>Date</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>#ORD-001</td>
                                    <td>John Smith</td>
                                    <td>Laptop Pro</td>
                                    <td>$1,299.00</td>
                                    <td><span class="badge bg-success">Completed</span></td>
                                    <td>2025-11-10</td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-primary">View</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>#ORD-002</td>
                                    <td>Jane Doe</td>
                                    <td>Wireless Mouse</td>
                                    <td>$49.99</td>
                                    <td><span class="badge bg-warning">Pending</span></td>
                                    <td>2025-11-10</td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-primary">View</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>#ORD-003</td>
                                    <td>Bob Johnson</td>
                                    <td>Mechanical Keyboard</td>
                                    <td>$159.00</td>
                                    <td><span class="badge bg-info">Processing</span></td>
                                    <td>2025-11-09</td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-primary">View</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>#ORD-004</td>
                                    <td>Alice Brown</td>
                                    <td>USB-C Hub</td>
                                    <td>$79.99</td>
                                    <td><span class="badge bg-success">Completed</span></td>
                                    <td>2025-11-09</td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-primary">View</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>#ORD-005</td>
                                    <td>Charlie Wilson</td>
                                    <td>Monitor 27"</td>
                                    <td>$399.00</td>
                                    <td><span class="badge bg-danger">Cancelled</span></td>
                                    <td>2025-11-08</td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-primary">View</button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>

<script>
// Dashboard initialization
document.addEventListener('DOMContentLoaded', function() {
    // Initialize tooltips
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
});
</script>

