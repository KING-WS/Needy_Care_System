<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid p-4 p-lg-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h1 class="h3 mb-0">Profile</h1>
            <p class="text-muted mb-0">Manage your profile information</p>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-lg-4">
            <div class="card">
                <div class="card-body text-center">
                    <img src="<c:url value='/assets/images/avatar-placeholder.svg'/>" 
                         alt="Profile" 
                         class="rounded-circle mb-3" 
                         width="150" 
                         height="150">
                    <h5 class="card-title">John Doe</h5>
                    <p class="text-muted">Administrator</p>
                    <button type="button" class="btn btn-primary btn-sm">Edit Profile</button>
                </div>
            </div>
        </div>
        <div class="col-lg-8">
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title mb-0">Profile Information</h5>
                </div>
                <div class="card-body">
                    <form>
                        <div class="row mb-3">
                            <label for="fullName" class="col-sm-3 col-form-label">Full Name</label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" id="fullName" value="John Doe">
                            </div>
                        </div>
                        <div class="row mb-3">
                            <label for="email" class="col-sm-3 col-form-label">Email</label>
                            <div class="col-sm-9">
                                <input type="email" class="form-control" id="email" value="john.doe@example.com">
                            </div>
                        </div>
                        <div class="row mb-3">
                            <label for="phone" class="col-sm-3 col-form-label">Phone</label>
                            <div class="col-sm-9">
                                <input type="tel" class="form-control" id="phone" value="+1 234 567 8900">
                            </div>
                        </div>
                        <div class="row mb-3">
                            <label for="bio" class="col-sm-3 col-form-label">Bio</label>
                            <div class="col-sm-9">
                                <textarea class="form-control" id="bio" rows="3">Full-stack developer with 5 years of experience.</textarea>
                            </div>
                        </div>
                        <div class="text-end">
                            <button type="submit" class="btn btn-primary">Save Changes</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>


