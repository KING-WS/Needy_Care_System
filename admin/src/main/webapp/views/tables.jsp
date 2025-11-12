<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid p-4 p-lg-5">
    <!-- Page Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h1 class="h3 mb-0">Tables</h1>
            <p class="text-muted mb-0">Advanced data tables with various features</p>
        </div>
    </div>

    <!-- Basic Table -->
    <div class="card mb-4">
        <div class="card-header">
            <h5 class="card-title mb-0">Basic Table</h5>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Name</th>
                            <th>Position</th>
                            <th>Office</th>
                            <th>Age</th>
                            <th>Salary</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>1</td>
                            <td>Tiger Nixon</td>
                            <td>System Architect</td>
                            <td>Edinburgh</td>
                            <td>61</td>
                            <td>$320,800</td>
                        </tr>
                        <tr>
                            <td>2</td>
                            <td>Garrett Winters</td>
                            <td>Accountant</td>
                            <td>Tokyo</td>
                            <td>63</td>
                            <td>$170,750</td>
                        </tr>
                        <tr>
                            <td>3</td>
                            <td>Ashton Cox</td>
                            <td>Junior Technical Author</td>
                            <td>San Francisco</td>
                            <td>66</td>
                            <td>$86,000</td>
                        </tr>
                        <tr>
                            <td>4</td>
                            <td>Cedric Kelly</td>
                            <td>Senior Javascript Developer</td>
                            <td>Edinburgh</td>
                            <td>22</td>
                            <td>$433,060</td>
                        </tr>
                        <tr>
                            <td>5</td>
                            <td>Airi Satou</td>
                            <td>Accountant</td>
                            <td>Tokyo</td>
                            <td>33</td>
                            <td>$162,700</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Hoverable Table -->
    <div class="card mb-4">
        <div class="card-header">
            <h5 class="card-title mb-0">Hoverable Table with Actions</h5>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th>
                                <input type="checkbox" class="form-check-input">
                            </th>
                            <th>Product</th>
                            <th>Category</th>
                            <th>Price</th>
                            <th>Stock</th>
                            <th>Status</th>
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
                                    <img src="<c:url value='/assets/images/product-placeholder.svg'/>" 
                                         alt="Product" 
                                         class="rounded me-2" 
                                         width="40" 
                                         height="40">
                                    <div>Laptop Pro 15"</div>
                                </div>
                            </td>
                            <td>Electronics</td>
                            <td>$1,299.00</td>
                            <td>25</td>
                            <td><span class="badge bg-success">In Stock</span></td>
                            <td>
                                <div class="btn-group btn-group-sm">
                                    <button class="btn btn-outline-primary">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                    <button class="btn btn-outline-secondary">
                                        <i class="bi bi-pencil"></i>
                                    </button>
                                    <button class="btn btn-outline-danger">
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
                                    <img src="<c:url value='/assets/images/product-placeholder.svg'/>" 
                                         alt="Product" 
                                         class="rounded me-2" 
                                         width="40" 
                                         height="40">
                                    <div>Wireless Mouse</div>
                                </div>
                            </td>
                            <td>Accessories</td>
                            <td>$49.99</td>
                            <td>150</td>
                            <td><span class="badge bg-success">In Stock</span></td>
                            <td>
                                <div class="btn-group btn-group-sm">
                                    <button class="btn btn-outline-primary">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                    <button class="btn btn-outline-secondary">
                                        <i class="bi bi-pencil"></i>
                                    </button>
                                    <button class="btn btn-outline-danger">
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
                                    <img src="<c:url value='/assets/images/product-placeholder.svg'/>" 
                                         alt="Product" 
                                         class="rounded me-2" 
                                         width="40" 
                                         height="40">
                                    <div>Mechanical Keyboard</div>
                                </div>
                            </td>
                            <td>Accessories</td>
                            <td>$159.00</td>
                            <td>0</td>
                            <td><span class="badge bg-danger">Out of Stock</span></td>
                            <td>
                                <div class="btn-group btn-group-sm">
                                    <button class="btn btn-outline-primary">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                    <button class="btn btn-outline-secondary">
                                        <i class="bi bi-pencil"></i>
                                    </button>
                                    <button class="btn btn-outline-danger">
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
                                    <img src="<c:url value='/assets/images/product-placeholder.svg'/>" 
                                         alt="Product" 
                                         class="rounded me-2" 
                                         width="40" 
                                         height="40">
                                    <div>USB-C Hub</div>
                                </div>
                            </td>
                            <td>Accessories</td>
                            <td>$79.99</td>
                            <td>5</td>
                            <td><span class="badge bg-warning">Low Stock</span></td>
                            <td>
                                <div class="btn-group btn-group-sm">
                                    <button class="btn btn-outline-primary">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                    <button class="btn btn-outline-secondary">
                                        <i class="bi bi-pencil"></i>
                                    </button>
                                    <button class="btn btn-outline-danger">
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
                <div class="text-muted">Showing 1 to 4 of 50 products</div>
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

    <!-- Bordered Table -->
    <div class="card">
        <div class="card-header">
            <h5 class="card-title mb-0">Bordered Table</h5>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered">
                    <thead class="table-light">
                        <tr>
                            <th>Invoice</th>
                            <th>Customer</th>
                            <th>Date</th>
                            <th>Amount</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>#INV-001</td>
                            <td>John Doe</td>
                            <td>2025-11-10</td>
                            <td>$1,299.00</td>
                            <td><span class="badge bg-success">Paid</span></td>
                        </tr>
                        <tr>
                            <td>#INV-002</td>
                            <td>Jane Smith</td>
                            <td>2025-11-09</td>
                            <td>$49.99</td>
                            <td><span class="badge bg-warning">Pending</span></td>
                        </tr>
                        <tr>
                            <td>#INV-003</td>
                            <td>Bob Johnson</td>
                            <td>2025-11-08</td>
                            <td>$159.00</td>
                            <td><span class="badge bg-success">Paid</span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>


