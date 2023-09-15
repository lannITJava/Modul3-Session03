create database Tonghop2;
use Tonghop2;
create table KHACHHANG(
MaKH varchar(4) primary key,
TenKH varchar(30) not null,
DiaChi varchar(50),
NgaySinh datetime,
SoDT varchar(15) unique
);
create table NHANVIEN(
MaNV varchar(4) primary key,
HoTen varchar(30) not null,
GioiTinh bit not null,
DiaChi varchar(50) not null,
NgaySinh datetime not null,
DienThoai varchar(15) ,
Email text,
NoiSinh varchar(20) not null,
NgayVaoLam datetime,
MaNQL varchar(4)
);
create table NHACUNGCAP(
MaNCC varchar(5) primary key,
TenNCC varchar(50) not null,
DiaChi varchar(50) not null,
DienThoai varchar(15) not null,
Email varchar(30) not null,
Website varchar(30)
);
create table LOAISP(
MaloaiSP varchar(4) primary key,
TenloaiSP varchar(30) not null,
GhiChu varchar(100) not null
);
create table SANPHAM(
MaSP varchar(4) primary key,
MaloaiSP varchar(4),
TenSP varchar(50)not null,
Donvitinh varchar(10) not null,
Ghichu varchar(100) 
);
create table PHIEUNHAP(
SoPN varchar(5) primary key,
MaNV varchar(4),
MaNCC varchar(4),
NgayBan datetime default (curdate()),
Ghichu text
);
alter table PHIEUNHAP
   rename column NgayBan to NgayNhap;
create table CTPHIEUNHAP(
SoPN varchar(5),
MaSP varchar(4),
Soluong smallint default(0),
Gianhap real check(Gianhap>=0),
primary key(SoPN, MaSP)
);
create table PHIEUXUAT(
SoPX varchar(5) primary key,
MaNV varchar(4) not null,
MaKH varchar(4) not null,
NgayBan datetime not null,
Ghichu text
);
create table CTPHIEUXUAT(
SoPX varchar(5),
MaSP varchar(4),
Soluong smallint not null check(Soluong>0),
Giaban real not null check( Giaban>0),
primary key ( SoPX, MaSP)
);
alter table SANPHAM
	add foreign key (MaloaiSP) references LOAISP(MaloaiSP);
alter table PHIEUNHAP
	add foreign key (MaNCC) references NHACUNGCAP(MaNCC);
alter table PHIEUNHAP
	add foreign key (MaNV) references NHANVIEN(MaNV);
alter table CTPHIEUNHAP
	add foreign key (MaSP) references SANPHAM(MaSP);
alter table CTPHIEUNHAP
	add foreign key (SoPN) references PHIEUNHAP(SoPN);
alter table PHIEUXUAT
	add foreign key (MaNV) references NHANVIEN(MaNV);
alter table PHIEUXUAT
	add foreign key (MaKH) references KHACHHANG(MaKH);
alter table CTPHIEUXUAT
	add foreign key (MaSP) references SANPHAM(MaSP);
alter table CTPHIEUXUAT
	add foreign key (SoPX) references PHIEUXUAT(SoPX);
insert into PHIEUNHAP
values ('PN001','NV05','NCC1','2023-2-25','fjvndj'),
('PN002','NV05','NCC1','2023-5-12','sdjnvfldj');
insert into CTPHIEUNHAP
values ('PN002','SP17',3,300),
('PN002','SP15',2,200);
insert into PHIEUXUAt
values ('PX005','NV05','KH01','2023-9-14','sdfkjsf'),
('PN006','NV05','KH02','2023-9-14','cjvhdsv');
insert into NHANVIEN
values ('NV06','Hoang Minh',0,'Cao Bang','2001-5-3','0366669999','minh@gmail.com','Cao Bang','2023-1-5','dsvs');
update KHACHHANG
set SoDT = '0311116666'
where MaKH = 'KH10';
update NHANVIEN
set DiaChi = 'Quang Nam'
where MaNV = 'NV05';
delete from NHANVIEN
where MaNV = 'NV06';
delete from SANPHAM
where MaSP = 'SP4';
select nv.MaNV, nv.HoTen, nv.GioiTinh, nv.DiaChi , nv.NgaySinh, nv.DienThoai
from NHANVIEN nv;
/*
Liệt kê thông tin về nhân viên trong cửa hàng, gồm: mã nhân viên, họ tên
nhân viên, giới tính, ngày sinh, địa chỉ, số điện thoại, tuổi. Kết quả sắp xếp
theo tuổi.
*/
select nv.MaNV, nv.HoTen, nv.Gioitinh, nv.DiaChi, nv.NgaySinh, nv.DienThoai, TIMESTAMPDIFF(YEAR, NgaySinh, CURDATE()) AS Tuoi
from NHANVIEN nv
 order by nv.NgaySinh DESC;

/*
Liệt kê các hóa đơn nhập hàng trong tháng 6/2018, gồm thông tin số phiếu
nhập, mã nhân viên nhập hàng, họ tên nhân viên, họ tên nhà cung cấp, ngày
nhập hàng, ghi chú
*/
select pn.SoPN, NHANVIEN.MaNV,NHANVIEN.HoTen,NHACUNGCAP.TenNCC, pn.NgayNhap, pn.Ghichu
from PHIEUNHAP pn 
join NHANVIEN  on pn.MaNV = NHANVIEN.MaNV
join NHACUNGCAP  on pn.MaNCC = NHACUNGCAP.MaNCC
WHERE MONTH(Ngaynhap) = 6
  AND YEAR(Ngaynhap) = 2018;
/*
Liệt kê tất cả sản phẩm có đơn vị tính là chai, gồm tất cả thông tin về sản
phẩm
*/
select sp.MaSP, sp.MaLoaiSP, sp.TenSP, sp.Donvitinh, sp.Ghichu
from SANPHAM sp
where sp.Donvitinh = 'chai';
/*
Liệt kê chi tiết nhập hàng trong tháng hiện hành gồm thông tin: số phiếu
nhập, mã sản phẩm, tên sản phẩm, loại sản phẩm, đơn vị tính, số lượng, giá
nhập, thành tiền.
*/
select ctpn.SoPN, ctpn.MaSP, sp.TenSP, lsp.TenloaiSP, sp.Donvitinh, ctpn.Soluong, ctpn.Gianhap, (ctpn.Soluong*ctpn.Gianhap) as Thanhtien
from CTPHIEUNHAP ctpn
JOIN SanPham sp ON ctpn.MaSP = sp.MaSP
         JOIN LoaiSP lsp ON sp.MaloaiSP = lsp.MaloaiSP
         JOIN PhieuNhap pn ON ctpn.SoPN = pn.SoPN
where MONTH(pn.Ngaynhap) = MONTH(CURDATE())
  AND YEAR(pn.Ngaynhap) = YEAR(CURDATE());
  /*
  Liệt kê các nhà cung cấp có giao dịch mua bán trong tháng hiện hành, gồm
thông tin: mã nhà cung cấp, họ tên nhà cung cấp, địa chỉ, số điện thoại,
email, số phiếu nhập, ngày nhập. Sắp xếp thứ tự theo ngày nhập hàng.
  */
  select pn.MaNCC, ncc.TenNCC, ncc.Diachi, ncc.Dienthoai, ncc.Email, pn.SoPN, pn.Ngaynhap
  from PHIEUNHAP pn
  join NHACUNGCAP ncc on pn.MaNCC = ncc.MaNCC
  where MONTH(pn.Ngaynhap) = MONTH(CURDATE())
  AND YEAR(pn.Ngaynhap) = YEAR(CURDATE());
  /*
  Liệt kê chi tiết hóa đơn bán hàng trong 6 tháng đầu năm 2023 gồm thông tin:
số phiếu xuất, nhân viên bán hàng, ngày bán, mã sản phẩm, tên sản phẩm,
đơn vị tính, số lượng, giá bán, doanh thu.
  */
  select ctpx.SoPX,
       nv.HoTen,
       px.NgayBan,
       ctpx.MaSP,
       sp.TenSP,
       sp.Donvitinh,
       ctpx.Soluong,
       ctpx.GiaBan,
       (ctpx.Soluong * ctpx.GiaBan) as DoanhThu
  from CTPHIEUXUAT ctpx
  JOIN PhieuXuat px ON ctpx.SoPX = px.SoPX
         JOIN NHANVIEN nv ON px.MaNV = nv.MaNV
         JOIN SanPham sp ON ctpx.MaSP = sp.MaSP
WHERE MONTH(px.NgayBan) BETWEEN 1 AND 6
  AND YEAR(px.NgayBan) = 2023;
  /*
  Hãy in danh sách khách hàng có ngày sinh nhật trong tháng hiện hành (gồm
tất cả thông tin của khách hàng)
  */
  select kh.MaKH, kh.TenKh, kh.Diachi, kh.NgaySinh, kh.SoDT
  from KHACHHANG kh
  where MONTH(kh.NgaySinh) = MONTH(CURDATE())
  /*
  Liệt kê các hóa đơn bán hàng từ ngày 15/01/2023 đến 15/02/2023 gồm các
thông tin: số phiếu xuất, nhân viên bán hàng, ngày bán, mã sản phẩm, tên
sản phẩm, đơn vị tính, số lượng, giá bán, doanh thu.
  */
  select ctpx.SoPX, nv.HoTen, px.NgayBan, ctpx.MaSP, sp.TenSp, sp.Donvitinh, ctpx.Soluong, ctpx.Giaban, (ctpx.Soluong * ctpx.Giaban) as doanhthu
  from CTPHIEUXUAT ctpx
  join PHIEUXUAT px on ctpx.SoPX = px.SoPX
  join NHANVIEN nv on PX.MaNV = nv.MaNV
  join SANPHAM sp on ctpx.MaSP = sp.MaSP
  where MONTH(px.NgayBan) BETWEEN 1 AND 2
 and year(px.NgayBan) = 2023
 and day(px.NgayBan) = 15;
 /*
 Liệt kê các hóa đơn mua hàng theo từng khách hàng, gồm các thông tin: số
phiếu xuất, ngày bán, mã khách hàng, tên khách hàng, trị giá.
 */
  select ctpx.SoPX, px.Ngayban, kh.MaKH, kh.TenKH, (ctpx.Soluong* ctpx.Giaban) as TriGia
  from CTPHIEUXUAT ctpx
  join PHIEUXUAT px on ctpx.SoPX = px.SoPX
  join KHACHHANG kh on px.MaKH = px.MaKH;
  /*
  Cho biết tổng số chai nước xả vải Comfort đã bán trong 6 tháng đầu năm
2023. Thông tin hiển thị: tổng số lượng.
  */
  select sum(ctpx.Soluong) as Tongsoluong
from CTPHIEUXUAT ctpx
join SANPHAM sp on ctpx.MaSP = sp.MaSP
join PhIEUXUAT px on ctpx.SoPX = px.SoPX
where sp.TenSp = 'Comfort'
and month(px.Ngayban) between 1 and 6
and year( px.Ngayban) = 2023 