using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace WMS.Models.Entities
{
    public partial class WMSDBContext : DbContext
    {
        public WMSDBContext()
        {
        }

        public WMSDBContext(DbContextOptions<WMSDBContext> options)
            : base(options)
        {
        }

        public virtual DbSet<Authorizations> Authorizations { get; set; }
        public virtual DbSet<AuthorizeType> AuthorizeType { get; set; }
        public virtual DbSet<Brand> Brand { get; set; }
        public virtual DbSet<Category> Category { get; set; }
        public virtual DbSet<Company> Company { get; set; }
        public virtual DbSet<Customers> Customers { get; set; }
        public virtual DbSet<Damage> Damage { get; set; }
        public virtual DbSet<ItemSpace> ItemSpace { get; set; }
        public virtual DbSet<Manufacturer> Manufacturer { get; set; }
        public virtual DbSet<OrderDetails> OrderDetails { get; set; }
        public virtual DbSet<OrderDispatch> OrderDispatch { get; set; }
        public virtual DbSet<OrderDispatchDetails> OrderDispatchDetails { get; set; }
        public virtual DbSet<OrderReturn> OrderReturn { get; set; }
        public virtual DbSet<OrderReturnDetails> OrderReturnDetails { get; set; }
        public virtual DbSet<Orders> Orders { get; set; }
        public virtual DbSet<Payment> Payment { get; set; }
        public virtual DbSet<PaymentMethods> PaymentMethods { get; set; }
        public virtual DbSet<PersonalDetail> PersonalDetail { get; set; }
        public virtual DbSet<ProductInsertion> ProductInsertion { get; set; }
        public virtual DbSet<ProductItems> ProductItems { get; set; }
        public virtual DbSet<ProductType> ProductType { get; set; }
        public virtual DbSet<Products> Products { get; set; }
        public virtual DbSet<Reck> Reck { get; set; }
        public virtual DbSet<Refunds> Refunds { get; set; }
        public virtual DbSet<SalesReturn> SalesReturn { get; set; }
        public virtual DbSet<SalesTransaction> SalesTransaction { get; set; }
        public virtual DbSet<Stock> Stock { get; set; }
        public virtual DbSet<StockAdjustment> StockAdjustment { get; set; }
        public virtual DbSet<StockTrace> StockTrace { get; set; }
        public virtual DbSet<Supplier> Supplier { get; set; }
        public virtual DbSet<UserType> UserType { get; set; }
        public virtual DbSet<Users> Users { get; set; }
        public virtual DbSet<Vat> Vat { get; set; }
        public virtual DbSet<Warehouse> Warehouse { get; set; }
        public virtual DbSet<WarehouseCapacityDefination> WarehouseCapacityDefination { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. See http://go.microsoft.com/fwlink/?LinkId=723263 for guidance on storing connection strings.
                optionsBuilder.UseSqlServer("Server=AbdHsn-Laptop;Database=WMSDB;User ID=AbdHsn-dbms; Password=123123;");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.HasAnnotation("ProductVersion", "2.2.6-servicing-10079");

            modelBuilder.Entity<Authorizations>(entity =>
            {
                entity.HasIndex(e => e.UserId)
                    .HasName("UQ__Authoriz__1788CC4D0FBC0E7D")
                    .IsUnique();

                entity.Property(e => e.AuthorizedDate).HasColumnType("datetime");

                entity.HasOne(d => d.AuthorizeType)
                    .WithMany(p => p.Authorizations)
                    .HasForeignKey(d => d.AuthorizeTypeId)
                    .HasConstraintName("FK__Authoriza__Autho__59063A47");
            });

            modelBuilder.Entity<AuthorizeType>(entity =>
            {
                entity.HasIndex(e => e.TypeName)
                    .HasName("UQ__Authoriz__D4E7DFA8C7F9AAF7")
                    .IsUnique();

                entity.Property(e => e.Description).HasMaxLength(50);

                entity.Property(e => e.TypeName).HasMaxLength(50);
            });

            modelBuilder.Entity<Brand>(entity =>
            {
                entity.HasIndex(e => e.Name)
                    .HasName("UQ__Brand__737584F6E51F9A50")
                    .IsUnique();

                entity.Property(e => e.BigImage).HasMaxLength(100);

                entity.Property(e => e.Name).HasMaxLength(100);

                entity.Property(e => e.SmallImage).HasMaxLength(100);
            });

            modelBuilder.Entity<Category>(entity =>
            {
                entity.Property(e => e.ParentCategory).HasMaxLength(15);

                entity.Property(e => e.SubCategory).HasMaxLength(15);
            });

            modelBuilder.Entity<Company>(entity =>
            {
                entity.Property(e => e.Address).HasMaxLength(250);

                entity.Property(e => e.BigLogo).HasMaxLength(100);

                entity.Property(e => e.Branch).HasMaxLength(20);

                entity.Property(e => e.Fax).HasMaxLength(20);

                entity.Property(e => e.Mobile).HasMaxLength(20);

                entity.Property(e => e.Name).HasMaxLength(30);

                entity.Property(e => e.RegistrationNo).HasMaxLength(20);

                entity.Property(e => e.SmallLogo).HasMaxLength(100);

                entity.Property(e => e.Telephone).HasMaxLength(15);

                entity.Property(e => e.Website).HasMaxLength(100);
            });

            modelBuilder.Entity<Customers>(entity =>
            {
                entity.HasIndex(e => e.Email)
                    .HasName("UQ__Customer__A9D105342D6D1D37")
                    .IsUnique();

                entity.HasIndex(e => e.Phone)
                    .HasName("UQ__Customer__5C7E359E545FCC7B")
                    .IsUnique();

                entity.Property(e => e.Address).HasMaxLength(200);

                entity.Property(e => e.Email).HasMaxLength(50);

                entity.Property(e => e.Icno)
                    .HasColumnName("ICNo")
                    .HasMaxLength(20);

                entity.Property(e => e.Name).HasMaxLength(100);

                entity.Property(e => e.Phone).HasMaxLength(15);

                entity.Property(e => e.Telephone).HasMaxLength(15);
            });

            modelBuilder.Entity<Damage>(entity =>
            {
                entity.HasIndex(e => e.DamageNo)
                    .HasName("UQ__Damage__8A0F29487DFA2C8C")
                    .IsUnique();

                entity.Property(e => e.DamageNo).HasMaxLength(20);

                entity.Property(e => e.EntryDate).HasColumnType("datetime");

                entity.Property(e => e.Note).HasMaxLength(100);

                entity.Property(e => e.ProductSerial).HasMaxLength(20);

                entity.Property(e => e.TotalAmount).HasColumnType("decimal(18, 2)");
            });

            modelBuilder.Entity<ItemSpace>(entity =>
            {
                entity.Property(e => e.LastUpdate).HasColumnType("datetime");
            });

            modelBuilder.Entity<Manufacturer>(entity =>
            {
                entity.HasIndex(e => e.ManufacturerName)
                    .HasName("UQ__Manufact__3B9CDE2ED12CA066")
                    .IsUnique();

                entity.Property(e => e.BigImage).HasMaxLength(100);

                entity.Property(e => e.ContactInfo).HasMaxLength(150);

                entity.Property(e => e.ManufacturerName).HasMaxLength(100);

                entity.Property(e => e.SmallImage).HasMaxLength(100);
            });

            modelBuilder.Entity<OrderDetails>(entity =>
            {
                entity.Property(e => e.CollectionDate).HasColumnType("datetime");

                entity.Property(e => e.DiscountAmount).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.DiscountRate).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.LastUpdate).HasColumnType("datetime");

                entity.Property(e => e.Price).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.ProductStatus).HasMaxLength(15);

                entity.Property(e => e.Total).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.VatAmount).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.VatRate).HasColumnType("decimal(18, 2)");
            });

            modelBuilder.Entity<OrderDispatch>(entity =>
            {
                entity.HasIndex(e => e.DispatchNo)
                    .HasName("UQ__OrderDis__434D95C739A83EF7")
                    .IsUnique();

                entity.Property(e => e.DispatchDate).HasColumnType("datetime");

                entity.Property(e => e.DispatchNo).HasMaxLength(20);

                entity.Property(e => e.Status).HasMaxLength(25);
            });

            modelBuilder.Entity<OrderDispatchDetails>(entity =>
            {
                entity.Property(e => e.LastUpdate).HasColumnType("datetime");

                entity.Property(e => e.ProductStatus).HasMaxLength(15);
            });

            modelBuilder.Entity<OrderReturn>(entity =>
            {
                entity.HasIndex(e => e.ReturnNo)
                    .HasName("UQ__OrderRet__F445F15AE54AFF67")
                    .IsUnique();

                entity.Property(e => e.ReturnDate).HasColumnType("datetime");

                entity.Property(e => e.ReturnNo).HasMaxLength(20);

                entity.Property(e => e.Status).HasMaxLength(25);
            });

            modelBuilder.Entity<OrderReturnDetails>(entity =>
            {
                entity.Property(e => e.LastUpdate).HasColumnType("datetime");

                entity.Property(e => e.ProductStatus).HasMaxLength(15);
            });

            modelBuilder.Entity<Orders>(entity =>
            {
                entity.HasIndex(e => e.OrderNo)
                    .HasName("UQ__Orders__C3907C75D1585BAD")
                    .IsUnique();

                entity.Property(e => e.BillingAddress).HasMaxLength(250);

                entity.Property(e => e.CollectionDate).HasColumnType("datetime");

                entity.Property(e => e.DiscountAmount).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.DiscountRate).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.GrandTotal).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.LastUpdate).HasColumnType("datetime");

                entity.Property(e => e.Note).HasMaxLength(100);

                entity.Property(e => e.OrderNo).HasMaxLength(20);

                entity.Property(e => e.OrderPlaceDate).HasColumnType("datetime");

                entity.Property(e => e.OrderStatus).HasMaxLength(15);

                entity.Property(e => e.VatAmount).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.VatRate).HasColumnType("decimal(18, 2)");
            });

            modelBuilder.Entity<Payment>(entity =>
            {
                entity.HasIndex(e => e.TransactionNo)
                    .HasName("UQ__Payment__554342D9B731789B")
                    .IsUnique();

                entity.Property(e => e.InstrumentNo).HasMaxLength(25);

                entity.Property(e => e.PaidAmount).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.TableReference).HasMaxLength(30);

                entity.Property(e => e.TransactionDate).HasColumnType("datetime");

                entity.Property(e => e.TransactionNo).HasMaxLength(20);
            });

            modelBuilder.Entity<PaymentMethods>(entity =>
            {
                entity.HasIndex(e => e.Name)
                    .HasName("UQ__PaymentM__737584F62EB6018B")
                    .IsUnique();

                entity.Property(e => e.Description).HasMaxLength(100);

                entity.Property(e => e.LogoPath).HasMaxLength(20);

                entity.Property(e => e.Name).HasMaxLength(20);

                entity.Property(e => e.Url).HasMaxLength(100);
            });

            modelBuilder.Entity<PersonalDetail>(entity =>
            {
                entity.HasIndex(e => e.UserId)
                    .HasName("UQ__Personal__1788CC4D4B2A1430")
                    .IsUnique();

                entity.Property(e => e.Address).HasMaxLength(200);

                entity.Property(e => e.Dob)
                    .HasColumnName("DOB")
                    .HasColumnType("date");

                entity.Property(e => e.Gender).HasMaxLength(10);

                entity.Property(e => e.Language).HasMaxLength(20);

                entity.Property(e => e.MaritalStatus).HasMaxLength(15);

                entity.Property(e => e.MobileNo).HasMaxLength(30);

                entity.Property(e => e.OtherPhone).HasMaxLength(100);

                entity.HasOne(d => d.User)
                    .WithOne(p => p.PersonalDetail)
                    .HasForeignKey<PersonalDetail>(d => d.UserId)
                    .HasConstraintName("FK__PersonalD__UserI__403A8C7D");
            });

            modelBuilder.Entity<ProductInsertion>(entity =>
            {
                entity.HasIndex(e => e.EntryNo)
                    .HasName("UQ__ProductI__F57A9DFC897AE8EA")
                    .IsUnique();

                entity.Property(e => e.EntryDate).HasColumnType("datetime");

                entity.Property(e => e.EntryNo).HasMaxLength(20);

                entity.Property(e => e.Note).HasMaxLength(100);
            });

            modelBuilder.Entity<ProductItems>(entity =>
            {
                entity.HasIndex(e => e.ItemSerial)
                    .HasName("UQ__ProductI__CA167712CADD7D4E")
                    .IsUnique();

                entity.Property(e => e.CreatedDate).HasColumnType("datetime");

                entity.Property(e => e.ItemSerial).HasMaxLength(30);

                entity.Property(e => e.ManualSerial).HasMaxLength(40);

                entity.Property(e => e.PackSerial).HasMaxLength(40);
            });

            modelBuilder.Entity<ProductType>(entity =>
            {
                entity.Property(e => e.TypeName).HasMaxLength(100);
            });

            modelBuilder.Entity<Products>(entity =>
            {
                entity.HasIndex(e => e.ProductCode)
                    .HasName("UQ__Products__2F4E024FA30573CB")
                    .IsUnique();

                entity.Property(e => e.BigImage).HasMaxLength(100);

                entity.Property(e => e.CostPrice).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.CreatedDate).HasColumnType("datetime");

                entity.Property(e => e.MetaTags).HasMaxLength(150);

                entity.Property(e => e.Name).HasMaxLength(50);

                entity.Property(e => e.ProductCode).HasMaxLength(6);

                entity.Property(e => e.SellingPrice).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.SmallImage).HasMaxLength(100);

                entity.Property(e => e.UpdateDate).HasColumnType("datetime");
            });

            modelBuilder.Entity<Reck>(entity =>
            {
                entity.Property(e => e.ReckName).HasMaxLength(20);
            });

            modelBuilder.Entity<Refunds>(entity =>
            {
                entity.HasIndex(e => e.RefundNo)
                    .HasName("UQ__Refunds__725A61B209FD4997")
                    .IsUnique();

                entity.Property(e => e.RefundAmount).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.RefundNo).HasMaxLength(20);

                entity.Property(e => e.RefundedDate).HasColumnType("datetime");

                entity.Property(e => e.SalesReturnNo).HasMaxLength(20);

                entity.HasOne(d => d.SalesReturn)
                    .WithMany(p => p.Refunds)
                    .HasForeignKey(d => d.SalesReturnId)
                    .HasConstraintName("FK__Refunds__SalesRe__5AEE82B9");
            });

            modelBuilder.Entity<SalesReturn>(entity =>
            {
                entity.HasIndex(e => e.SalesReturnNo)
                    .HasName("UQ__SalesRet__E0900466B0452FA9")
                    .IsUnique();

                entity.Property(e => e.OrderNo).HasMaxLength(20);

                entity.Property(e => e.ProductSerial).HasMaxLength(20);

                entity.Property(e => e.Reason).HasMaxLength(100);

                entity.Property(e => e.ReturnDate).HasColumnType("datetime");

                entity.Property(e => e.SalesReturnNo).HasMaxLength(20);

                entity.Property(e => e.Status).HasMaxLength(15);

                entity.Property(e => e.TotalAmount).HasColumnType("decimal(18, 2)");

                entity.HasOne(d => d.Customer)
                    .WithMany(p => p.SalesReturn)
                    .HasForeignKey(d => d.CustomerId)
                    .HasConstraintName("FK__SalesRetu__Custo__5BE2A6F2");
            });

            modelBuilder.Entity<SalesTransaction>(entity =>
            {
                entity.Property(e => e.PaidAmount).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.SaleTransactionNo).HasMaxLength(20);

                entity.Property(e => e.TransactionDate).HasColumnType("datetime");

                entity.HasOne(d => d.Customer)
                    .WithMany(p => p.SalesTransaction)
                    .HasForeignKey(d => d.CustomerId)
                    .HasConstraintName("FK__SalesTran__Custo__5CD6CB2B");

                entity.HasOne(d => d.PaymentMethod)
                    .WithMany(p => p.SalesTransaction)
                    .HasForeignKey(d => d.PaymentMethodId)
                    .HasConstraintName("FK__SalesTran__Payme__5DCAEF64");
            });

            modelBuilder.Entity<Stock>(entity =>
            {
                entity.Property(e => e.CreatedDate).HasColumnType("datetime");

                entity.Property(e => e.LastUpdate).HasColumnType("datetime");
            });

            modelBuilder.Entity<StockAdjustment>(entity =>
            {
                entity.HasIndex(e => e.AdjustmentNo)
                    .HasName("UQ__StockAdj__E60D0EF1D06C6850")
                    .IsUnique();

                entity.Property(e => e.AdjustmentNo).HasMaxLength(20);

                entity.Property(e => e.EntryDate).HasColumnType("datetime");

                entity.Property(e => e.Note).HasMaxLength(100);
            });

            modelBuilder.Entity<StockTrace>(entity =>
            {
                entity.Property(e => e.CreatedDate).HasColumnType("datetime");

                entity.Property(e => e.Note).HasMaxLength(100);

                entity.Property(e => e.ReferenceId).HasMaxLength(100);

                entity.Property(e => e.TableReference).HasMaxLength(30);
            });

            modelBuilder.Entity<Supplier>(entity =>
            {
                entity.HasIndex(e => e.Email)
                    .HasName("UQ__Supplier__A9D10534EA803924")
                    .IsUnique();

                entity.HasIndex(e => e.Phone)
                    .HasName("UQ__Supplier__5C7E359EA5101B85")
                    .IsUnique();

                entity.Property(e => e.Address).HasMaxLength(150);

                entity.Property(e => e.CompanyName).HasMaxLength(20);

                entity.Property(e => e.Email).HasMaxLength(15);

                entity.Property(e => e.Fax).HasMaxLength(15);

                entity.Property(e => e.Phone).HasMaxLength(15);

                entity.Property(e => e.SupplierName).HasMaxLength(20);

                entity.Property(e => e.Telephone).HasMaxLength(15);
            });

            modelBuilder.Entity<UserType>(entity =>
            {
                entity.HasIndex(e => e.TypeName)
                    .HasName("UQ__UserType__D4E7DFA807F3DAE4")
                    .IsUnique();

                entity.Property(e => e.TypeName).HasMaxLength(30);
            });

            modelBuilder.Entity<Users>(entity =>
            {
                entity.HasIndex(e => e.Email)
                    .HasName("UQ__Users__A9D10534D36E8D6C")
                    .IsUnique();

                entity.HasIndex(e => e.UserName)
                    .HasName("UQ__Users__C9F28456F39F222E")
                    .IsUnique();

                entity.Property(e => e.BigImage).HasMaxLength(100);

                entity.Property(e => e.CreateDate).HasColumnType("datetime");

                entity.Property(e => e.Email).HasMaxLength(50);

                entity.Property(e => e.FirstName).HasMaxLength(100);

                entity.Property(e => e.LastName).HasMaxLength(100);

                entity.Property(e => e.Password).HasMaxLength(100);

                entity.Property(e => e.SmallImage).HasMaxLength(100);

                entity.Property(e => e.TempField).HasMaxLength(50);

                entity.Property(e => e.UserName).HasMaxLength(200);
            });

            modelBuilder.Entity<Vat>(entity =>
            {
                entity.Property(e => e.Description).HasMaxLength(100);

                entity.Property(e => e.Title).HasMaxLength(10);

                entity.Property(e => e.VatRate).HasColumnType("decimal(18, 2)");
            });

            modelBuilder.Entity<Warehouse>(entity =>
            {
                entity.Property(e => e.Location).HasMaxLength(100);

                entity.Property(e => e.Title).HasMaxLength(100);
            });
        }
    }
}
