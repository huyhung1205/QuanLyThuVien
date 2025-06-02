-- 31/5: Huy Hung
-- Sach: TuaSach đổi tên TenSach, ISBN => xóa
-- TheLoai: Mota => xóa
-- MuonSach: đổi tên MuonTraSach, thêm cột MaMuonSach làm khóa chính duy nhất
-- TraSach: thêm cột MaMuonSach làm khóa chính duy nhất

--1)CSDL của đồ án chứa ít nhất 7 bảng (table)
	CREATE Database QuanLyThuVien;
	USE QuanLyThuVien;
	GO


	-- 1. Bảng Thể Loại:
	CREATE TABLE TheLoai (
		MaTheLoai VARCHAR(10) PRIMARY KEY,
		TenTheLoai NVARCHAR(255) NOT NULL
	);
	GO

	-- 2. Bảng Nhà Xuất Bản: 
	CREATE TABLE NhaXuatBan (
		MaNhaXuatBan VARCHAR(10) PRIMARY KEY,
		TenNhaXuatBan NVARCHAR(50) NOT NULL,
		DiaChi NVARCHAR(255) NOT NULL,
		SDT VARCHAR(15) NOT NULL,
		Email NVARCHAR(100)
	);
	GO

	-- 3. Bảng Tác Giả:
	CREATE TABLE TacGia (
		MaTacGia VARCHAR(10) PRIMARY KEY,
		TenTacGia NVARCHAR(100) NOT NULL,
		TieuSu NVARCHAR(255)
	);
	GO

	-- 4. Bảng Sách:
	CREATE TABLE Sach (
		MaSach VARCHAR(10) PRIMARY KEY,
		TenSach NVARCHAR(255) NOT NULL,
		MaNhaXuatBan VARCHAR(10),
		MaTheLoai VARCHAR(10),
		NamSanXuat INT NOT NULL,
		SoLuong int NOT NULL,
		FOREIGN KEY (MaNhaXuatBan) REFERENCES NhaXuatBan(MaNhaXuatBan) ON DELETE CASCADE,
		FOREIGN KEY (MaTheLoai) REFERENCES TheLoai(MaTheLoai) ON DELETE CASCADE
		-- ON DELETE CASCADE Tất cả các bản ghi liên quan trong bảng con (bảng có khóa ngoại) sẽ tự động bị xóa theo
	);
	GO

	-- 5. Bảng Sách - Tác Giả:
	CREATE TABLE SachTacGia (
		MaSach VARCHAR(10),
		MaTacGia VARCHAR(10),
		PRIMARY KEY (MaSach, MaTacGia),
		FOREIGN KEY (MaSach) REFERENCES Sach(MaSach) ON DELETE CASCADE,
		FOREIGN KEY (MaTacGia) REFERENCES TacGia(MaTacGia) ON DELETE CASCADE
		-- ON DELETE CASCADE Tất cả các bản ghi liên quan trong bảng con (bảng có khóa ngoại) sẽ tự động bị xóa theo
	);
	GO

	-- 6. Bảng Nhân Viên: 
	CREATE TABLE NhanVien (
		MaNhanVien VARCHAR(10) PRIMARY KEY,
		TenNhanVien NVARCHAR(100) NOT NULL,
		ChucVu NVARCHAR(50) NOT NULL,
		NgayVaoLam DATE
	);
	GO

	-- 7. Bảng Quản Lý Sách: 
	CREATE TABLE QuanLySach (
		MaNhanVien VARCHAR(10),
		MaSach VARCHAR(10),
		NgayQuanLy DATE,
		PRIMARY KEY (MaNhanVien, MaSach),
		FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien) ON DELETE CASCADE,
		FOREIGN KEY (MaSach) REFERENCES Sach(MaSach) ON DELETE CASCADE
		-- ON DELETE CASCADE Tất cả các bản ghi liên quan trong bảng con (bảng có khóa ngoại) sẽ tự động bị xóa theo
	);
	GO

	-- 8. Bảng Thành Viên:
	CREATE TABLE ThanhVien (
		MaThanhVien VARCHAR(10) PRIMARY KEY,
		TenThanhVien NVARCHAR(255) NOT NULL,
		DiaChi NVARCHAR(255) NOT NULL,
		SDT VARCHAR(15) NOT NULL,
		Email NVARCHAR(255)
	);
	GO

	-- 9. Bảng Quản Lý Thành Viên: 
	CREATE TABLE QuanLyThanhVien (
		MaNhanVien VARCHAR(10),
		MaThanhVien VARCHAR(10),
		NgayDangKi DATE,
		PRIMARY KEY (MaNhanVien, MaThanhVien),
		FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien) ON DELETE CASCADE,
		FOREIGN KEY (MaThanhVien) REFERENCES ThanhVien(MaThanhVien) ON DELETE CASCADE
		-- ON DELETE CASCADE Tất cả các bản ghi liên quan trong bảng con (bảng có khóa ngoại) sẽ tự động bị xóa theo
	);
	GO

	-- 10. Bảng Mượn Sách:
	CREATE TABLE MuonSach (
		MaMuonSach VARCHAR(10),
		MaSach VARCHAR(10),
		MaThanhVien VARCHAR(10),
		MaNhanVien VARCHAR(10),
		NgayMuon DATE,
		NgayPhaiTra DATE,
		PRIMARY KEY (MaMuonSach),
		FOREIGN KEY (MaSach) REFERENCES Sach(MaSach),
		FOREIGN KEY (MaThanhVien) REFERENCES ThanhVien(MaThanhVien) ON DELETE CASCADE,
		FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien) ON DELETE CASCADE,
		CHECK (NgayPhaiTra >= NgayMuon)
		-- ON DELETE CASCADE Tất cả các bản ghi liên quan trong bảng con (bảng có khóa ngoại) sẽ tự động bị xóa theo
	);
	GO
	-- 11. Bảng Trả Sách: 
	-- Lưu các sách đã trả
	CREATE TABLE TraSach (
		MaMuonSach VARCHAR(10),
		MaSach VARCHAR(10),
		MaThanhVien VARCHAR(10),
		MaNhanVien VARCHAR(10),
		NgayMuon DATE,
		NgayTra DATE,
		PRIMARY KEY (MaMuonSach),
		FOREIGN KEY (MaSach) REFERENCES Sach(MaSach),
		FOREIGN KEY (MaThanhVien) REFERENCES ThanhVien(MaThanhVien) ON DELETE CASCADE,
		FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien) ON DELETE CASCADE
		-- ON DELETE CASCADE Tất cả các bản ghi liên quan trong bảng con (bảng có khóa ngoại) sẽ tự động bị xóa theo
	);
	GO

	-- Chèn dữ liệu cho từng bảng
	--Chèn bảng TheLoai
	INSERT INTO TheLoai (MaTheLoai, TenTheLoai) VALUES
	('TL0001', N'Khoa học'),
	('TL0002', N'Văn học'),
	('TL0003', N'Lịch sử'),
	('TL0004', N'Thiếu nhi'),
	('TL0005', N'Tâm lý'),
	('TL0006', N'Kinh tế'),
	('TL0007', N'Công nghệ'),
	('TL0008', N'Y học'),
	('TL0009', N'Ngoại ngữ'),
	('TL0010', N'Địa lý');
	GO

	-- Chèn bảng NhaXuatBan
	INSERT INTO NhaXuatBan VALUES
	('NXB0001', N'NXB Kim Đồng', N'Hà Nội', '0123456789', 'kimdong@nxb.vn'),
	('NXB0002', N'NXB Trẻ', N'TP. HCM', '0987654321', 'nxbtre@nxb.vn'),
	('NXB0003', N'NXB Giáo Dục', N'Hà Nội', '0912345678', 'giaoduc@nxb.vn'),
	('NXB0004', N'NXB Tổng Hợp', N'TP. HCM', '0901122334', 'tonghop@nxb.vn'),
	('NXB0005', N'NXB Lao Động', N'Đà Nẵng', '0933445566', 'laodong@nxb.vn'),
	('NXB0006', N'NXB Y Học', N'Huế', '0945566778', 'yhoc@nxb.vn'),
	('NXB0007', N'NXB Văn Học', N'Cần Thơ', '0967788990', 'vanhoc@nxb.vn'),
	('NXB0008', N'NXB Đại Học Quốc Gia', N'Hà Nội', '0977889900', 'dhqg@nxb.vn'),
	('NXB0009', N'NXB Tài Chính', N'TP. HCM', '0999888777', 'taichinh@nxb.vn'),
	('NXB0010', N'NXB Khoa Học', N'Hà Nội', '0112233445', 'khoahoc@nxb.vn');
	GO

	-- Chèn bảng TacGia
	INSERT INTO TacGia VALUES
	('TG0001', N'Nguyễn Nhật Ánh', N'Tác giả nổi tiếng với các tác phẩm thiếu nhi'),
	('TG0002', N'Nam Cao', N'Tác giả hiện thực phê phán'),
	('TG0003', N'Tô Hoài', N'Tác giả của "Dế Mèn phiêu lưu ký"'),
	('TG0004', N'Ngô Tất Tố', N'Tác giả của "Tắt đèn"'),
	('TG0005', N'Xuân Diệu', N'Nhà thơ lãng mạn nổi tiếng'),
	('TG0006', N'Hồ Chí Minh', N'Nhà cách mạng, nhà văn'),
	('TG0007', N'Võ Nguyên Giáp', N'Tác giả viết về lịch sử quân sự'),
	('TG0008', N'Bill Gates', N'Tác giả sách công nghệ và khởi nghiệp'),
	('TG0009', N'Adam Khoo', N'Tác giả sách phát triển bản thân'),
	('TG0010', N'Dale Carnegie', N'Tác giả sách kỹ năng sống');
	GO

	-- Chèn bảng Sach
	INSERT INTO Sach (MaSach, TenSach, MaNhaXuatBan, MaTheLoai, NamSanXuat, SoLuong) VALUES
	('S0001', N'Cho tôi xin một vé đi tuổi thơ', 'NXB0001', 'TL0004', 2008, 20),
	('S0002', N'Lão Hạc', 'NXB0002', 'TL0002', 1943, 10),
	('S0003', N'Dế Mèn phiêu lưu ký', 'NXB0003', 'TL0004', 1941, 20),
	('S0004', N'Tắt đèn', 'NXB0004', 'TL0002', 1939, 30),
	('S0005', N'Nhật ký trong tù', 'NXB0005', 'TL0002', 1942, 25),
	('S0006', N'Tiểu sử Võ Nguyên Giáp', 'NXB0006', 'TL0003', 2005, 5),
	('S0007', N'Tư duy nhanh và chậm', 'NXB0007', 'TL0005', 2011, 1),
	('S0008', N'Cuộc sống không giới hạn', 'NXB0008', 'TL0005', 2014, 2),
	('S0009', N'Tư duy tích cực', 'NXB0009', 'TL0005', 2012, 5),
	('S0010', N'Tiếng Anh giao tiếp', 'NXB0010', 'TL0009', 2020, 5);
	GO
	
	-- Chèn bảng SachTacGia
	INSERT INTO SachTacGia VALUES
	('S0001', 'TG0001'),
	('S0002', 'TG0002'),
	('S0003', 'TG0003'),
	('S0004', 'TG0004'),
	('S0005', 'TG0006'),
	('S0006', 'TG0007'),
	('S0007', 'TG0009'),
	('S0008', 'TG0009'),
	('S0009', 'TG0010'),
	('S0010', 'TG0008');
	GO
	
	-- Chèn bảng NhanVien
	INSERT INTO NhanVien VALUES
	('NV0001', N'Nguyễn Văn An', N'Thủ thư', '2020-01-10'),
	('NV0002', N'Lê Thị Bình', N'Thủ thư', '2021-03-15'),
	('NV0003', N'Trần Văn Cao', N'Quản lý', '2019-06-20'),
	('NV0004', N'Phạm Thị Diệu', N'Thủ thư', '2022-02-25'),
	('NV0005', N'Đặng Văn Viên', N'Trưởng phòng', '2018-09-12'),
	('NV0006', N'Hoàng Thị phi', N'Kế toán', '2020-05-05'),
	('NV0007', N'Vũ Văn Gia', N'Thủ thư', '2023-01-10'),
	('NV0008', N'Ngô Thị Hoa', N'Thủ thư', '2021-07-22'),
	('NV0009', N'Lý Văn Tự', N'Thủ thư', '2020-11-11'),
	('NV0010', N'Bùi Thị Xuân', N'Thư ký', '2019-04-04');
	GO

	-- Chèn bảng QuanLySach
	INSERT INTO QuanLySach VALUES
	('NV0001', 'S0001', '2021-01-01'),
	('NV0001', 'S0002', '2021-01-01'),
	('NV0002', 'S0003', '2021-02-01'),
	('NV0002', 'S0004', '2021-02-01'),
	('NV0003', 'S0005', '2020-03-01'),
	('NV0004', 'S0006', '2022-03-01'),
	('NV0005', 'S0007', '2019-01-01'),
	('NV0006', 'S0008', '2020-04-01'),
	('NV0007', 'S0009', '2023-01-01'),
	('NV0008', 'S0010', '2021-07-01');
	GO

	-- Chèn bảng ThanhVien
	INSERT INTO ThanhVien VALUES
	('TV0001', N'Nguyễn Hữu Khánh', N'Hà Nội', '0911111111', 'tv01@mail.com'),
	('TV0002', N'Lê Hồng Linh', N'TP. HCM', '0922222222', 'tv02@mail.com'),
	('TV0003', N'Trần Minh M', N'Đà Nẵng', '0933333333', 'tv03@mail.com'),
	('TV0004', N'Phạm Hải Nsm', N'Cần Thơ', '0944444444', 'tv04@mail.com'),
	('TV0005', N'Đặng Quang Ong', N'Bình Dương', '0955555555', 'tv05@mail.com'),
	('TV0006', N'Hoàng Kim Phúc', N'Huế', '0966666666', 'tv06@mail.com'),
	('TV0007', N'Vũ Thị Quỳnh', N'Nghệ An', '0977777777', 'tv07@mail.com'),
	('TV0008', N'Ngô Văn Trung', N'Thái Bình', '0988888888', 'tv08@mail.com'),
	('TV0009', N'Lý Thị Sinh', N'Tuyên Quang', '0999999999', 'tv09@mail.com'),
	('TV0010', N'Bùi Đức Trung', N'Quảng Nam', '0900000000', 'tv10@mail.com');
	GO

	-- Chèn bảng QuanLyThanhVien
	INSERT INTO QuanLyThanhVien VALUES
	('NV0001', 'TV0001', '2021-01-01'),
	('NV0001', 'TV0002', '2021-01-02'),
	('NV0002', 'TV0003', '2021-03-03'),
	('NV0002', 'TV0004', '2021-04-04'),
	('NV0003', 'TV0005', '2021-05-05'),
	('NV0004', 'TV0006', '2021-06-06'),
	('NV0005', 'TV0007', '2021-07-07'),
	('NV0006', 'TV0008', '2021-08-08'),
	('NV0007', 'TV0009', '2021-09-09'),
	('NV0008', 'TV0010', '2021-10-10');
	GO

	-- Chèn bảng MuonSach
	INSERT INTO MuonSach VALUES
	('MS0001', 'S0001', 'TV0001', 'NV0001', '2024-01-01', '2024-01-15'),
	('MS0002', 'S0002', 'TV0002', 'NV0001', '2024-01-02', '2024-01-16'),
	('MS0003', 'S0003', 'TV0003', 'NV0002', '2024-01-03', '2024-01-17'),
	('MS0004', 'S0004', 'TV0004', 'NV0002', '2024-01-04', '2024-01-18'),
	('MS0005', 'S0005', 'TV0005', 'NV0003', '2024-01-05', '2024-01-19'),
	('MS0006', 'S0006', 'TV0006', 'NV0004', '2024-01-06', '2024-01-20'),
	('MS0007', 'S0007', 'TV0007', 'NV0005', '2024-01-07', '2024-01-21'),
	('MS0008', 'S0008', 'TV0008', 'NV0006', '2024-01-08', '2024-01-22'),
	('MS0009', 'S0009', 'TV0009', 'NV0007', '2024-01-09', '2024-01-23'),
	('MS0010', 'S0010', 'TV0010', 'NV0008', '2024-01-10', '2024-01-24');
	GO

	-- Chèn bảng TraSach
	INSERT INTO TraSach VALUES
	('MS0001', 'S0001', 'TV0001', 'NV0001', '2024-01-01', '2024-01-10'),
	('MS0002', 'S0002', 'TV0002', 'NV0001', '2024-01-02', '2024-01-15'),
	('MS0003', 'S0003', 'TV0003', 'NV0002', '2024-01-03', '2024-01-14'),
	('MS0004', 'S0004', 'TV0004', 'NV0002', '2024-01-04', '2024-01-20'),
	('MS0005', 'S0005', 'TV0005', 'NV0003', '2024-01-05', '2024-01-22'),
	('MS0006', 'S0006', 'TV0006', 'NV0004', '2024-01-06', '2024-01-18'),
	('MS0007', 'S0007', 'TV0007', 'NV0005', '2024-01-07', '2024-01-23'),
	('MS0008', 'S0008', 'TV0008', 'NV0006', '2024-01-08', '2024-01-19'),
	('MS0009', 'S0009', 'TV0009', 'NV0007', '2024-01-09', '2024-01-21'),
	('MS0010', 'S0010', 'TV0010', 'NV0008', '2024-01-10', '2024-01-24');
	GO

	--xem tổng quang các bảng trong csdl
	SELECT * FROM TraSach;
	SELECT * FROM MuonSach;
	SELECT * FROM QuanLyThanhVien;
	SELECT * FROM QuanLySach;
	SELECT * FROM SachTacGia;
	SELECT * FROM Sach;
	SELECT * FROM TacGia;
	SELECT * FROM ThanhVien;
	SELECT * FROM NhanVien;
	SELECT * FROM TheLoai;
	SELECT * FROM NhaXuatBan;
	go
	--xóa các bảng trong csdl
	DELETE FROM TraSach;
	DELETE FROM MuonSach;
	DELETE FROM QuanLyThanhVien;
	DELETE FROM QuanLySach;
	DELETE FROM SachTacGia;
	DELETE FROM Sach;
	DELETE FROM TacGia;
	DELETE FROM ThanhVien;
	DELETE FROM NhanVien;
	DELETE FROM TheLoai;
	DELETE FROM NhaXuatBan;
	go
--2)Cài đặt CSDL trên SQL Server bằng cách sử dụng giao diện hoặc câu lệnh SQL 
--3)Tạo khoảng 35 câu truy vấn:

	--a.Truy vấn đơn giản: 3 câu

			-- 1. Liệt kê tất cả các cuốn sách trong thư viện với tên thể loại và nhà xuất bản
			SELECT s.MaSach, s.TenSach, tl.TenTheLoai, nxb.TenNhaXuatBan
			FROM Sach s
			JOIN TheLoai tl ON s.MaTheLoai = tl.MaTheLoai
			JOIN NhaXuatBan nxb ON s.MaNhaXuatBan = nxb.MaNhaXuatBan;

			-- 2. Liệt kê danh sách các thành viên đã mượn sách
			SELECT DISTINCT tv.MaThanhVien, tv.TenThanhVien, tv.SDT
			FROM MuonSach m
			JOIN ThanhVien tv ON m.MaThanhVien = tv.MaThanhVien;

			-- 3. Tìm tất cả sách do tác giả "Nguyễn Nhật Ánh" viết
			SELECT s.MaSach, s.TenSach
			FROM Sach s
			JOIN SachTacGia stg ON s.MaSach = stg.MaSach
			JOIN TacGia tg ON stg.MaTacGia = tg.MaTacGia
			WHERE tg.TenTacGia = N'Nguyễn Nhật Ánh';

	--b.Truy vấn với Aggregate Functions: 7 câu

			-- 4. Đếm tổng số sách trong thư viện
			SELECT COUNT(*) AS TongSoSach
			FROM Sach;

			-- 5.Tính số lượng sách theo từng thể loại
			SELECT tl.TenTheLoai, COUNT(s.MaSach) AS SoLuongSach
			FROM TheLoai tl
			LEFT JOIN Sach s ON s.MaTheLoai = tl.MaTheLoai
			GROUP BY tl.TenTheLoai;

			-- 6. Tính tổng số sách đang được quản lý bởi từng nhân viên
			SELECT nv.TenNhanVien, COUNT(qls.MaSach) AS SoLuongSachQuanLy
			FROM QuanLySach qls
			JOIN NhanVien nv ON qls.MaNhanVien = nv.MaNhanVien
			GROUP BY nv.TenNhanVien;

			-- 7. Thống kê số lần mượn sách của từng thành viên
			SELECT tv.TenThanhVien, COUNT(*) AS SoLanMuon
			FROM MuonSach m
			JOIN ThanhVien tv ON m.MaThanhVien = tv.MaThanhVien
			GROUP BY tv.TenThanhVien;

			-- 8. Tìm năm xuất bản sớm nhất và muộn nhất của sách trong thư viện
			SELECT MIN(NamSanXuat) AS NamXuatBanSomNhat, MAX(NamSanXuat) AS NamXuatBanMuonNhat
			FROM Sach;

			-- 9. Tính số sách mỗi nhà xuất bản đã phát hành
			SELECT nxb.TenNhaXuatBan, COUNT(s.MaSach) AS SoLuongSach
			FROM NhaXuatBan nxb
			LEFT JOIN Sach s ON s.MaNhaXuatBan = nxb.MaNhaXuatBan
			GROUP BY nxb.TenNhaXuatBan;

			--10.Tính trung bình số lượng sách hiện có theo thể loại
			SELECT tl.TenTheLoai, AVG(s.SoLuong) AS TrungBinhSoLuong
			FROM TheLoai tl
			JOIN Sach s ON s.MaTheLoai = tl.MaTheLoai
			GROUP BY tl.TenTheLoai;

	--c.Truy vấn với mệnh đề having: 5 câu

			-- 11. Liệt kê các thể loại có từ 2 sách trở lên
			SELECT tl.TenTheLoai, COUNT(s.MaSach) AS SoLuongSach
			FROM TheLoai tl
			JOIN Sach s ON tl.MaTheLoai = s.MaTheLoai
			GROUP BY tl.TenTheLoai
			HAVING COUNT(s.MaSach) >= 2;

			-- 12. Liệt kê các thành viên đã mượn hơn 3 lần
			SELECT tv.TenThanhVien, COUNT(*) AS SoLanMuon
			FROM MuonSach m
			JOIN ThanhVien tv ON m.MaThanhVien = tv.MaThanhVien
			GROUP BY tv.TenThanhVien
			HAVING COUNT(*) > 3;

			-- 13. Liệt kê các nhân viên đang quản lý trên 5 cuốn sách
			SELECT nv.TenNhanVien, COUNT(qls.MaSach) AS SoSachQuanLy
			FROM QuanLySach qls
			JOIN NhanVien nv ON qls.MaNhanVien = nv.MaNhanVien
			GROUP BY nv.TenNhanVien
			HAVING COUNT(qls.MaSach) > 5;

			-- 14. Liệt kê nhà xuất bản có từ 3 cuốn sách trở lên
			SELECT nxb.TenNhaXuatBan, COUNT(s.MaSach) AS SoLuongSach
			FROM NhaXuatBan nxb
			JOIN Sach s ON s.MaNhaXuatBan = nxb.MaNhaXuatBan
			GROUP BY nxb.TenNhaXuatBan
			HAVING COUNT(s.MaSach) >= 3;

			-- 15. Liệt kê thể loại có trung bình số lượng sách trên 10
			SELECT tl.TenTheLoai, AVG(s.SoLuong) AS TrungBinhSoLuong
			FROM TheLoai tl
			JOIN Sach s ON tl.MaTheLoai = s.MaTheLoai
			GROUP BY tl.TenTheLoai
			HAVING AVG(s.SoLuong) > 10;

	--d.Truy vấn lớn nhất, nhỏ nhất: 3 câu

			-- 16. Tìm cuốn sách xuất bản sớm nhất (năm nhỏ nhất)
			SELECT TOP 1 MaSach, TenSach, NamSanXuat
			FROM Sach
			ORDER BY NamSanXuat ASC;

			-- 17. Tìm thành viên đã mượn sách gần đây nhất
			SELECT TOP 1 tv.MaThanhVien, tv.TenThanhVien, m.NgayMuon
			FROM MuonSach m
			JOIN ThanhVien tv ON m.MaThanhVien = tv.MaThanhVien
			ORDER BY m.NgayMuon DESC;


			-- 18. Tìm nhân viên quản lý nhiều sách nhất
			SELECT TOP 1 nv.MaNhanVien, nv.TenNhanVien, COUNT(qls.MaSach) AS SoSachQuanLy
			FROM QuanLySach qls
			JOIN NhanVien nv ON qls.MaNhanVien = nv.MaNhanVien
			GROUP BY nv.MaNhanVien, nv.TenNhanVien
			ORDER BY SoSachQuanLy DESC;

	--e.Truy vấn Không/chưa có: (Not In và left/right join): 5 câu
		-- left: lấy bảng  chính làm gốc-- right: lấy bảng tham gia làm gốc
			-- 19. Liệt kê các sách chưa từng được mượn
			SELECT s.MaSach, s.TenSach
			FROM Sach s
			LEFT JOIN MuonSach m ON s.MaSach = m.MaSach
			WHERE m.MaSach IS NULL;

			-- 20. Thành viên chưa từng mượn sách
			SELECT * 
			FROM ThanhVien 
			WHERE MaThanhVien NOT IN (SELECT MaThanhVien FROM MuonSach);

			-- 21. Danh sách tất cả các sách từng được mượn
			SELECT s.MaSach, s.TenSach
			FROM Sach s
			JOIN MuonSach ms ON s.MaSach = ms.MaSach

			-- 22. Tác giả chưa viết sách nào
			SELECT tg.* 
			FROM TacGia tg 
			LEFT JOIN SachTacGia stg ON tg.MaTacGia = stg.MaTacGia 
			WHERE stg.MaTacGia IS NULL;

			-- 23. Nhà xuất bản chưa xuất bản sách nào
			SELECT * FROM NhaXuatBan WHERE MaNhaXuatBan NOT IN (SELECT MaNhaXuatBan FROM Sach);

	--f.Truy vấn Hợp UNION /Giao INTERSECT/Trừ EXCEPT: 3 câu
			-- Hợp: UNION -- Giao: INTERSECT -- Trừ: EXCEPT

			-- 24. Mã sách đã được mượn nhưng chưa được trả
			SELECT MaSach FROM MuonSach
			EXCEPT
			SELECT MaSach FROM TraSach;

			-- 25. Sách đã được mượn hoặc đã được trả
			SELECT MaSach FROM MuonSach
			UNION
			SELECT MaSach FROM TraSach;

			-- 26. Liệt kê thành viên đã mượn VÀ đã trả sách
			SELECT MaThanhVien FROM MuonSach
			INTERSECT
			SELECT MaThanhVien FROM TraSach;

	--g.Truy vấn Update, Delete:  7 câu
			-- 27. Cập nhật địa chỉ của thành viên TV01
			UPDATE ThanhVien SET DiaChi = N'Hồ Chí Minh' WHERE MaThanhVien = 'TV01';
			-- 28. Cập nhật số điện thoại của thành viên TV0001
			UPDATE ThanhVien SET SDT = '0901234567' WHERE MaThanhVien = 'TV0001';
			-- 29. Cập nhật tên sách S001
			UPDATE Sach SET TenSach = N'Ve lại tuổi thơ' WHERE MaSach = 'S001';
			-- 30. Xóa thành viên có MaThanhVien = 'TV10'
			DELETE FROM ThanhVien WHERE MaThanhVien = 'TV10';
			-- 31. Xóa sách có MaSach = 'S001'
			DELETE FROM Sach WHERE MaSach = 'S001';
			-- 32. Xóa nhân viên có MaNhanVien = 'NV10'
			DELETE FROM NhanVien WHERE MaNhanVien = 'NV10';
			-- 33. Xóa sách không có tác giả
			DELETE FROM Sach WHERE MaSach NOT IN (SELECT MaSach FROM SachTacGia);

	--h.Truy vấn sử dụng phép Chia: 2 câu

			-- 34. Thành viên đã mượn tất cả các sách
			SELECT MaThanhVien
			FROM MuonSach
			GROUP BY MaThanhVien
			HAVING COUNT(DISTINCT MaSach) = (
				SELECT COUNT(DISTINCT MaSach) FROM Sach
			);
			GO

			-- 35. Thành viên đã mượn tất cả các sách của thể loại 'TL01'
			SELECT MaThanhVien
			FROM MuonSach
			JOIN Sach ON MuonSach.MaSach = Sach.MaSach
			WHERE Sach.MaTheLoai = 'TL01'
			GROUP BY MaThanhVien
			HAVING COUNT(DISTINCT MuonSach.MaSach) = (
				SELECT COUNT(DISTINCT MaSach) FROM Sach WHERE MaTheLoai = 'TL01'
			);
			GO
--4)Tạo ít nhất 5 thủ tục/hàm và 3 trigger
	-- Thủ tục/ hàm:
		-- 1. Thủ tục: Thêm sách mới
		CREATE PROCEDURE ThemSach
			@MaSach VARCHAR(10),
			@TenSach NVARCHAR(255),
			@MaNhaXuatBan VARCHAR(10),
			@MaTheLoai VARCHAR(10),
			@NamSanXuat INT,
			@SoLuong INT
		AS
		BEGIN
			INSERT INTO Sach (MaSach, TenSach, MaNhaXuatBan, MaTheLoai, NamSanXuat, SoLuong)
			VALUES (@MaSach, @TenSach, @MaNhaXuatBan, @MaTheLoai, @NamSanXuat, @SoLuong);
		END;
		GO

		-- 2. Thủ tục: Tìm sách theo tên gần đúng
		CREATE PROCEDURE TimSachTheoTen
			@Ten NVARCHAR(255)
		AS
		BEGIN
			SELECT * FROM Sach
			WHERE TenSach LIKE '%' + @Ten + '%';
		END;
		GO

		-- 3. Thủ tục: Thống kê số sách theo thể loại 
		CREATE PROCEDURE ThongKeSachTheoTheLoai
		AS
		BEGIN
			SELECT tl.TenTheLoai, COUNT(s.MaSach) AS SoLuongSach
			FROM TheLoai tl
			LEFT JOIN Sach s ON tl.MaTheLoai = s.MaTheLoai
			GROUP BY tl.TenTheLoai;
		END;
		GO

		-- 4. Hàm: Trả về tổng số sách đang có
		CREATE FUNCTION TongSoSach()
		RETURNS INT
		AS
		BEGIN
			DECLARE @Tong INT;
			SELECT @Tong = SUM(SoLuong) FROM Sach;
			RETURN @Tong;
		END;
		GO

		-- 5. Hàm: Trả về số lần mượn của một thành viên 
		CREATE FUNCTION SoLanMuonCuaThanhVien(@MaTV VARCHAR(10))
		RETURNS INT
		AS
		BEGIN
			DECLARE @SoLan INT;
			SELECT @SoLan = COUNT(*) FROM MuonSach WHERE MaThanhVien = @MaTV;
			RETURN @SoLan;
		END;
		GO
	-- Trigger:
		-- 1. Trigger: Kiểm tra số lượng sách > 0 trước khi mượn
		CREATE TRIGGER KiemTraSoLuongSachTruocKhiMuon
		ON MuonSach
		INSTEAD OF INSERT
		AS
		BEGIN
			IF EXISTS (
				SELECT 1 
				FROM INSERTED i
				JOIN Sach s ON i.MaSach = s.MaSach
				WHERE s.SoLuong <= 0
			)
			BEGIN
				RAISERROR(N'Sách không còn trong kho.', 16, 1);
			END
			ELSE
			BEGIN
				INSERT INTO MuonSach
				SELECT * FROM INSERTED;

				UPDATE s
				SET SoLuong = SoLuong - 1
				FROM Sach s
				JOIN INSERTED i ON s.MaSach = i.MaSach;
			END
		END;
		GO
		-- 2. Trigger: Tự động tăng lại số lượng khi xóa mượn sách (trả sách)
		CREATE TRIGGER TangSoLuongKhiXoaMuonSach
		ON MuonSach
		AFTER DELETE
		AS
		BEGIN
			UPDATE s
			SET SoLuong = SoLuong + 1
			FROM Sach s
			JOIN DELETED d ON s.MaSach = d.MaSach;
		END;
		GO
		-- 3. Trigger: Kiểm tra email hợp lệ khi thêm thành viên
		CREATE TRIGGER KiemTraEmailThanhVien
		ON ThanhVien
		INSTEAD OF INSERT
		AS
		BEGIN
			IF EXISTS (
				SELECT 1
				FROM INSERTED
				WHERE Email NOT LIKE '%@%.%'
			)
			BEGIN
				RAISERROR(N'Email không hợp lệ. Phải có định dạng như abc@xyz.com', 16, 1);
				RETURN;
			END

			INSERT INTO ThanhVien (MaThanhVien, TenThanhVien, DiaChi, SDT, Email)
			SELECT MaThanhVien, TenThanhVien, DiaChi, SDT, Email
			FROM INSERTED;
		END;
		GO
--5)Tạo 3 người dùng và cấp quyền cho mỗi người dùng với các quyền khác nhau:
	-- Kiểm tra người dùng
	SELECT name FROM sys.database_principals WHERE name = 'thanhvienUser';
	-- Xóa người dùng
	DROP USER thanhvienUser;
	-- Xóa tài khoản
	DROP LOGIN thanhvien;
	-- Kiểm tra lại các phiên làm việc
	SELECT spid, loginame FROM sys.sysprocesses WHERE loginame = 'thanhvien';
	-- Ngắt phiên làm việc của user
	KILL 74;


	-- Tạo đăng nhập
	CREATE LOGIN quantrivien WITH PASSWORD = 'quantrivien';
	CREATE LOGIN nhanvien WITH PASSWORD = 'nhanvien';
	CREATE LOGIN thanhvien WITH PASSWORD = 'thanhvien';
	-- Tạo người dùng
	CREATE USER quantrivienUser FOR LOGIN quantrivien;
	CREATE USER nhanvienUser FOR LOGIN nhanvien;
	CREATE USER thanhvienUser FOR LOGIN thanhvien;


	-- Cấp toàn quyền cho quản trị viên (quantrivien)
	ALTER ROLE db_owner ADD MEMBER quantrivienUser;

	-- Cấp quyền cho thủ thư (thuthu)
	-- Cấp quyền đầy đủ trên 5 bảng chính
	GRANT SELECT, INSERT, UPDATE, DELETE ON NhanVien TO nhanvienUser;
	GRANT SELECT, INSERT, UPDATE, DELETE ON ThanhVien TO nhanvienUser;
	GRANT SELECT, INSERT, UPDATE, DELETE ON Sach TO nhanvienUser;
	GRANT SELECT, INSERT, UPDATE, DELETE ON MuonSach TO nhanvienUser;
	GRANT SELECT, INSERT, UPDATE, DELETE ON TraSach TO nhanvienUser;
	-- Cấp quyền xem (SELECT) trên các bảng còn lại
	GRANT SELECT ON TheLoai TO nhanvienUser;
	GRANT SELECT ON TacGia TO nhanvienUser;
	GRANT SELECT ON SachTacGia TO nhanvienUser;
	GRANT SELECT ON NhaXuatBan TO nhanvienUser;
	GRANT SELECT ON QuanLySach TO nhanvienUser;

	-- Cấp quyền cho thành viên (thanhvien)
	-- Chỉ được xem thông tin sách và thông tin cá nhân
	GRANT SELECT ON Sach TO thanhvienUser;
	GRANT SELECT ON TheLoai TO thanhvienUser;
	GRANT SELECT ON NhaXuatBan TO thanhvienUser;
	GRANT SELECT ON TacGia TO thanhvienUser;
	GRANT SELECT ON SachTacGia TO thanhvienUser;
	GRANT SELECT ON ThanhVien TO thanhvienUser;
	-- Tạo bảng ánh xạ LOGIN ↔ MaTV
	CREATE TABLE DangNhapThanhVien (
		LoginName NVARCHAR(100) PRIMARY KEY,              -- Tên login SQL Server
		MaThanhVien VARCHAR(10) NOT NULL,                 -- Phù hợp với bảng ThanhVien
		FOREIGN KEY (MaThanhVien) REFERENCES ThanhVien(MaThanhVien)
	);
	-- Thêm dữ liệu vào bảng ánh xạ
	INSERT INTO DangNhapThanhVien (LoginName, MaThanhVien)
	VALUES ('thanhvien', 'TV0001');
	GO
	-- Tạo VIEW chỉ hiển thị sách đã mượn của người dùng đó
	CREATE VIEW LichSuMuonCuaToi
	AS
	SELECT mts.*
	FROM MuonSach mts
	JOIN DangNhapThanhVien dntv ON mts.MaThanhVien = dntv.MaThanhVien
	WHERE dntv.LoginName = SYSTEM_USER;
	GO
	-- SYSTEM_USER là hàm SQL Server trả về tên người đang đăng nhập
	-- Cấp quyền cho thanhvienUser
	GRANT SELECT ON LichSuMuonCuaToi TO thanhvienUser;


--6)Tạo giao diện chương trình (Winform hoặc Webform) với các mức chức năng như sau:
		---a.Cập nhật: Thêm, Sửa, Xóa dữ liệu trên từng bảng
			-- Đăng nhập.
			-- Quản lý Sách (Tìm kiếm: mã sách, tên sách)
			-- Quản lý Độc giả (Tìm kiếm: mã tác giả, tên tác giả)
			-- Quản lý Mượn trả sách
				-- Hiển thị sách đã mượn
				-- Hiển thị sách đã trả
			-- Quản lý nhân viên
			-- Quản lý thành viên
			-- Thống kê: 
				-- Số lương sách đã mượn theo khoảng thời gian
				-- Số lương sách đã mượn theo thành viên
				-- Số lương sách chưa trả
		--b.Truy vấn dữ liệu trên form
	--Thống kê, báo cáo