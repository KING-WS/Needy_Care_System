<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid p-4 p-lg-5">
    <!-- Page Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h1 class="h3 mb-0">Users</h1>
            <p class="text-muted mb-0">Manage your application users</p>
        </div>
        <button type="button" class="btn btn-primary">
            <i class="bi bi-person-plus me-2"></i>
            Add New User
        </button>
    </div>

    <!-- Search and Filter -->
    <div class="card mb-4">
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-4">
                    <input type="search" class="form-control" placeholder="Search users...">
                </div>
                <div class="col-md-3">
                    <select class="form-select">
                        <option selected>All Roles</option>
                        <option value="admin">Admin</option>
                        <option value="user">User</option>
                        <option value="manager">Manager</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <select class="form-select">
                        <option selected>All Status</option>
                        <option value="active">Active</option>
                        <option value="inactive">Inactive</option>
                        <option value="banned">Banned</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <button type="button" class="btn btn-outline-secondary w-100">
                        <i class="bi bi-funnel me-2"></i>Filter
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Users Table -->
    <div class="card">
        <div class="card-header">
            <h5 class="card-title mb-0">User List</h5>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th>
                                <input type="checkbox" class="form-check-input">
                            </th>
                            <th>User</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th>Status</th>
                            <th>Last Active</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                <input type="checkbox" class="form-check-input">
                            </td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <img src="<c:url value='/assets/images/avatar-placeholder.svg'/>" 
                                         alt="User" 
                                         class="rounded-circle me-2" 
                                         width="40" 
                                         height="40">
                                    <div>
                                        <div class="fw-semibold">John Doe</div>
                                        <small class="text-muted">ID: #USR001</small>
                                    </div>
                                </div>
                            </td>
                            <td>john.doe@example.com</td>
                            <td><span class="badge bg-primary">Admin</span></td>
                            <td><span class="badge bg-success">Active</span></td>
                            <td>2 hours ago</td>
                            <td>
                                <div class="btn-group btn-group-sm">
                                    <button type="button" class="btn btn-outline-primary">
                                        <i class="bi bi-pencil"></i>
                                    </button>
                                    <button type="button" class="btn btn-outline-danger">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input type="checkbox" class="form-check-input">
                            </td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <img src="<c:url value='/assets/images/avatar-placeholder.svg'/>" 
                                         alt="User" 
                                         class="rounded-circle me-2" 
                                         width="40" 
                                         height="40">
                                    <div>
                                        <div class="fw-semibold">Jane Smith</div>
                                        <small class="text-muted">ID: #USR002</small>
                                    </div>
                                </div>
                            </td>
                            <td>jane.smith@example.com</td>
                            <td><span class="badge bg-info">Manager</span></td>
                            <td><span class="badge bg-success">Active</span></td>
                            <td>5 hours ago</td>
                            <td>
                                <div class="btn-group btn-group-sm">
                                    <button type="button" class="btn btn-outline-primary">
                                        <i class="bi bi-pencil"></i>
                                    </button>
                                    <button type="button" class="btn btn-outline-danger">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input type="checkbox" class="form-check-input">
                            </td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <img src="<c:url value='/assets/images/avatar-placeholder.svg'/>" 
                                         alt="User" 
                                         class="rounded-circle me-2" 
                                         width="40" 
                                         height="40">
                                    <div>
                                        <div class="fw-semibold">Bob Johnson</div>
                                        <small class="text-muted">ID: #USR003</small>
                                    </div>
                                </div>
                            </td>
                            <td>bob.johnson@example.com</td>
                            <td><span class="badge bg-secondary">User</span></td>
                            <td><span class="badge bg-warning">Inactive</span></td>
                            <td>2 days ago</td>
                            <td>
                                <div class="btn-group btn-group-sm">
                                    <button type="button" class="btn btn-outline-primary">
                                        <i class="bi bi-pencil"></i>
                                    </button>
                                    <button type="button" class="btn btn-outline-danger">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input type="checkbox" class="form-check-input">
                            </td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <img src="<c:url value='/assets/images/avatar-placeholder.svg'/>" 
                                         alt="User" 
                                         class="rounded-circle me-2" 
                                         width="40" 
                                         height="40">
                                    <div>
                                        <div class="fw-semibold">Alice Brown</div>
                                        <small class="text-muted">ID: #USR004</small>
                                    </div>
                                </div>
                            </td>
                            <td>alice.brown@example.com</td>
                            <td><span class="badge bg-secondary">User</span></td>
                            <td><span class="badge bg-success">Active</span></td>
                            <td>1 hour ago</td>
                            <td>
                                <div class="btn-group btn-group-sm">
                                    <button type="button" class="btn btn-outline-primary">
                                        <i class="bi bi-pencil"></i>
                                    </button>
                                    <button type="button" class="btn btn-outline-danger">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="card-footer">
            <div class="d-flex justify-content-between align-items-center">
                <div class="text-muted">Showing 1 to 4 of 100 users</div>
                <nav>
                    <ul class="pagination pagination-sm mb-0">
                        <li class="page-item disabled">
                            <a class="page-link" href="#" tabindex="-1">Previous</a>
                        </li>
                        <li class="page-item active"><a class="page-link" href="#">1</a></li>
                        <li class="page-item"><a class="page-link" href="#">2</a></li>
                        <li class="page-item"><a class="page-link" href="#">3</a></li>
                        <li class="page-item">
                            <a class="page-link" href="#">Next</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>
</div>


