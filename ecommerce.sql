-- E-commerce Website for Electronics Products

create database if not exists ecommerce;

-- 1. Bảng lưu thông tin chi nhánh
CREATE TABLE Branches (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    address TEXT NOT NULL,
    phone VARCHAR(20) NOT NULL,
    image VARCHAR(255),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
); -- done
--
-- 2. Bảng lưu thông tin user
CREATE TABLE Users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    fullname VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address TEXT,
    avatar VARCHAR(255),
    salary DECIMAL(12, 2) DEFAULT 0,
    hireday DATE,                      -- khóa ngoại tới bảng Roles
    branchId BIGINT,                             -- nếu là nhân viên - khóa ngoại tới bảng Branches
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (branchId) REFERENCES Branches(id)
); -- done
--
-- 3. Bảng lưu thông tin role  ( 'Customer', 'Staff', 'Manager', 'Admin' )
CREATE TABLE Roles (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
); -- done
--
CREATE TABLE UserRole ( -- nhiều nhiều
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    userId BIGINT NOT NULL,
    roleId BIGINT NOT NULL
); -- done
--
-- 4. Bảng lưu thông tin danh mục sản phẩm
CREATE TABLE Categories (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    parentId BIGINT DEFAULT NULL,
    image VARCHAR(255),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
); -- done

-- 5. Bảng lưu thông tin nhà sản xuất
CREATE TABLE Manufacturers (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255),
    website VARCHAR(255),
    image VARCHAR(255),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
); -- done

-- 6. Bảng lưu thông tin sản phẩm
CREATE TABLE Products (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL CHECK ( price > 0 ),
    categoryId BIGINT NOT NULL,
    manufacturerId BIGINT NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (categoryId) REFERENCES Categories(id),
    FOREIGN KEY (manufacturerId) REFERENCES Manufacturers(id)
); -- done

-- 7. Bảng lưu thông tin số lượng tồn kho sản phẩm tại chi nhánh
CREATE TABLE Stocks (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    branchId BIGINT NOT NULL,
    productIduser_role BIGINT NOT NULL,
    quantity INT NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (branchId) REFERENCES Branches(id),
    FOREIGN KEY (productId) REFERENCES Products(id)
); -- done

-- 8. Bảng lưu thông tin các thuộc tính của sản phẩm ( màu sắc, kích thước, tính năng ... )
CREATE TABLE Attributes (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(255) NOT NULL, -- color
    name VARCHAR(255) NOT NULL, -- Màu sắc
    categoryId BIGINT NOT NULL,             -- Khóa ngoại tới bảng Categories
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (categoryId) REFERENCES Categories(id)
); -- done

-- 9. Bảng lưu thông tin các giá trị của thuộc tính
CREATE TABLE AttributeValues (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    attributeId BIGINT NOT NULL, -- Thuộc tính (VD: Màu sắc - id: 1) : khóa ngoại tới bảng Attributes,
    code VARCHAR(255) NOT NULL,  -- black
    name VARCHAR(255) NOT NULL,  -- Tên của thuộc tính (VD: Đen, 128GB) -- Màu đen
    value VARCHAR(255) ,         -- Nếu thuộc tính color sẽ có màu (VD: #333) -- #333
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (attributeId) REFERENCES Attributes(id)
); -- done

CREATE TABLE ProductAttributeValues ( -- nhiều nhiều
    productId BIGINT NOT NULL,              -- Sản phẩm - khóa ngoại tới bảng Products
    attributeValueId BIGINT NOT NULL,       -- Giá trị thuộc tính - khóa ngoại tới bảng AttributeValues
    PRIMARY KEY (ProductID, AttributeValueID) -- Khóa chính ghép
); -- done

-- 10. Bảng lưu thông tin địa chỉ nhận hàng
CREATE TABLE ShippingAddress (
	id BIGINT PRIMARY KEY AUTO_INCREMENT,
    address TEXT NOT NULL,
    userId BIGINT NOT NULL,         -- khóa ngoại tới bảng Users
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (userId) REFERENCES Users(id)
); -- done

-- 11. Bảng lưu thông tin trạng thái order đơn hàng
CREATE TABLE OrderStatus (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(50) NOT NULL,    -- -- 'Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'
    status VARCHAR(100) NOT NULL,         
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
); -- done

-- 12. Bảng lưu thông tin đơn hàng
CREATE TABLE Orders (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    userId BIGINT NOT NULL,             -- Khóa ngoại tới bảng users
    totalAmount DECIMAL(10, 2) NOT NULL,
    expectedDeliveryDate DATE,           -- Ngày dự kiến giao hàng
    customerNote TEXT,                   -- Ghi chú khách hàng
    shippingAddressId BIGINT,               -- Khóa ngoại tới bảng ShippingAddress
    orderStatusId BIGINT NOT NULL,          -- Khóa ngoại tới bảng OrderStatus
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (userId) REFERENCES Users(id),
    FOREIGN KEY (shippingAddressId) REFERENCES ShippingAddress(id),
    FOREIGN KEY (orderStatusId) REFERENCES OrderStatus(id)
); -- done

-- 13. Bảng lưu chi tiết đơn hàng
CREATE TABLE OrderDetails (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    orderId BIGINT NOT NULL,                -- Khóa ngoại tới bảng Orders
    productId BIGINT NOT NULL,              -- Khóa ngoại tới bảng Products
    quantity INT NOT NULL,
    unitPrice DECIMAL(10, 2) NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (orderId) REFERENCES Orders(id),
    FOREIGN KEY (productId) REFERENCES Products(id)
); -- done

-- 14. Bảng lưu phương thức thanh toán
CREATE TABLE PaymentMethods (  
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(50) NOT NULL,    -- 'Credit Card', 'PayPal', 'Cash', 'Bank Transfer'
    name VARCHAR(50) NOT NULL,    -- Giao tận nhà, Thẻ tín dụng
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
); -- done

-- 15. Bảng lưu thông tin thanh toán
CREATE TABLE PaymentStatus (  
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(50) NOT NULL,    -- 'Pending', 'Completed', 'Failed'
    name VARCHAR(50) NOT NULL,    -- Đã thanh toán, Thanh toán thất bại
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
); -- done

-- 16. Bảng lưu lịch sử thanh toán one-to-one
CREATE TABLE Payments (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    orderId BIGINT UNIQUE NOT NULL,                  -- Khóa ngoại tới bảng Orders
    paymentMethodId BIGINT,          -- Khóa ngoại tới bảng PaymentMethods
    paymentStatusId BIGINT,                   -- Khóa ngoại tới bảng PaymentStatus
    amount DECIMAL(10, 2) NOT NULL,
    paidAt TIMESTAMP,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (orderId) REFERENCES Orders(id),
    FOREIGN KEY (paymentMethodId) REFERENCES PaymentMethods(id),
    FOREIGN KEY (paymentStatusId) REFERENCES PaymentStatus(id)
); -- done

-- 17. Bảng lưu thông tin về việc đánh giá và rating sản phẩm, nếu là Delivered thì cho phép đánh giá
CREATE TABLE Reviews (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,     
    productId BIGINT NOT NULL,                       -- ID sản phẩm được đánh giá
    userId BIGINT NOT NULL,                      -- ID khách hàng thực hiện đánh giá
    orderId BIGINT,                                  -- ID đơn hàng chứa sản phẩm (đảm bảo đã mua hàng)
    rating INT CHECK (Rating BETWEEN 1 AND 5), -- Điểm đánh giá từ 1 đến 5
    comment TEXT,                                 -- Nội dung bình luận
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (productId) REFERENCES Products(id),
    FOREIGN KEY (userId) REFERENCES Users(id),
    FOREIGN KEY (orderId) REFERENCES Orders(id)
);

-- 18. Bảng lưu trữ các liên quan về product và user
CREATE TABLE ProductActions (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    productId BIGINT NOT NULL,
    userId BIGINT NOT NULL,
    code VARCHAR(50) NOT NULL,
    name VARCHAR(50) NOT NULL, -- đã xem, like, ...
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (productId) REFERENCES Products(id),
    FOREIGN KEY (userId) REFERENCES Users(id)
);

-- 19. Bảng lưu thông tin chat hỗ trợ
CREATE TABLE SupportChats (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    senderId BIGINT NOT NULL,        -- Khóa ngoại tới bảng users
    receiverId BIGINT NOT NULL,           -- Khóa ngoại tới bảng users
    message TEXT NOT NULL,
    sentAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (senderId) REFERENCES users(id),
    FOREIGN KEY (receiverId) REFERENCES users(id)
);-- done

-- 20. Bảng lưu thông tin doanh thu
CREATE TABLE Revenues (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    branchId BIGINT NOT NULL,
    orderId BIGINT NOT NULL,
    totalRevenue DECIMAL(10, 2) NOT NULL,
    revenueDate DATE NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (orderId) REFERENCES Orders(id),
    FOREIGN KEY (branchId) REFERENCES Branches(id)
);-- done
