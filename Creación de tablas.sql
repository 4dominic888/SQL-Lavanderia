create database [La Percha]
use [La Percha]


/*******************************
================================
	Creación de tablas
================================
********************************/



/***************************
	Tablas Complementarias
    ****************************/

CREATE TABLE Genero(
	ID int not null primary key identity,
	[Value] nvarchar(100)
);

CREATE TABLE TipoEmpleado(
	ID int not null primary key identity,
	[Value] nvarchar(100) not null,
	Descripcion text
);

CREATE TABLE TipoServicio(
	ID int not null primary key identity,
	[Value] nvarchar(100) not null,
	Descripcion text,
	PrecioPorRopa money check(PrecioPorRopa > 0) not null
);

CREATE TABLE TipoProducto(
	ID int not null primary key identity,
	[Value] nvarchar(100) not null
);

CREATE TABLE TipoRopa(
	ID int not null primary key identity,
	[Value] nvarchar(100) not null
);

CREATE TABLE ColorRopa(
	ID int not null primary key identity,
	[Value] nvarchar(100) not null
);

CREATE TABLE MaterialRopa(
	ID int not null primary key identity,
	[Value] nvarchar(100) not null
);

CREATE TABLE MetodoPago(
	ID int not null primary key identity,
	[Value] nvarchar(100) not null
);

CREATE TABLE EstadoMaquinaria(
	ID int not null primary key identity,
	[Value] nvarchar(100) not null,
	Descripcion text
);

CREATE TABLE MarcaMaquinaria(
	ID int not null primary key identity,
	[Value] nvarchar(100) not null
);

CREATE TABLE MarcaProducto(
	ID int not null primary key identity,
	[Value] nvarchar(100) not null
);

---------------------------------------------------------

/***************************
	Tablas Principales
    ****************************/

CREATE TABLE Cliente(
	ID varchar(25) not null unique,
	ID_genero int not null foreign key references Genero(ID),
	DNI char(8) not null unique,
	Apellido_paterno nvarchar(100) not null,
	Apellido_materno nvarchar(100) not null,
	Nombre nvarchar(100) not null
);

CREATE TABLE Empleado(
	ID varchar(25) not null unique,
	ID_genero int not null foreign key references Genero(ID),
	DNI char(8) not null unique,
	Apellido_paterno nvarchar(100) not null,
	Apellido_materno nvarchar(100) not null,
	Nombre nvarchar(100) not null,
	ID_TipoEmpleado int not null foreign key references TipoEmpleado(ID),
	Sueldo money check (Sueldo >= 800 and Sueldo <= 2500 and Sueldo is not null)
);

CREATE TABLE Ropa(
	ID varchar(25) not null unique,
	ID_TipoRopa int not null foreign key references TipoRopa(ID),
	ID_Color int not null foreign key references ColorRopa(ID),
	ID_Material int not null foreign key references MaterialRopa(ID),
	ID_Cliente varchar(25) not null foreign key references Cliente(ID),
	Peso float not null,
	Detalle text
);

CREATE TABLE Ticket(
	ID varchar(25) not null unique,
	ID_Empleado varchar(25) not null foreign key references Empleado(ID),
	ID_Cliente varchar(25) not null foreign key references Cliente(ID),
	ID_TipoServicio int not null foreign key references TipoServicio(ID),
	ID_MetodoPago int not null foreign key references MetodoPago(ID),
	Fecha_Recepcion datetime default getdate(),

	--Estos campos se calcularan con datos previos de otras tablas
	Fecha_Entrega datetime,
	Precio money check(Precio >= 0) default 0
);

CREATE TABLE Lavadora(
	ID varchar(25) not null unique,
	ID_Estado int not null foreign key references EstadoMaquinaria(ID),
	ID_Marca int not null foreign key references MarcaMaquinaria(ID),
	Modelo nvarchar(100),
	ConsumoEnergia float check(ConsumoEnergia > 0) not null, --en kWh
	Detalle text,
	CapacidadMaxima float check(CapacidadMaxima > 0) not null --Peso en kg
);

CREATE TABLE Secadora(
	ID varchar(25) not null unique,
	ID_Estado int not null foreign key references EstadoMaquinaria(ID),
	ID_Marca int not null foreign key references MarcaMaquinaria(ID),
	Modelo nvarchar(100),
	ConsumoEnergia float check(ConsumoEnergia > 0) not null, --en kWh
	Detalle text,
	CapacidadMaxima float check(CapacidadMaxima > 0) not null --Peso en kg
);

CREATE TABLE Planchadora(
	ID varchar(25) not null unique,
	ID_Estado int not null foreign key references EstadoMaquinaria(ID),
	ID_Marca int not null foreign key references MarcaMaquinaria(ID),
	Modelo nvarchar(100),
	ConsumoEnergia float check(ConsumoEnergia > 0) not null, --en kWh
	Detalle text
);

CREATE TABLE Producto(
	ID varchar(25) not null unique,
	ID_TipoProducto int not null foreign key references TipoProducto(ID),
	ID_MarcaProducto int not null foreign key references MarcaProducto(ID),
	Precio float check(Precio > 0) not null,
	Descripcion text,
	Stock int check(Stock >= 0) not null
);


/***************************************
	Tablas Relacionadas muchos a muchos
   ***********************************/

CREATE TABLE LimpiezaRopa(
	ID int not null primary key identity,
	ID_Ropa varchar(25) not null foreign key references Ropa(ID),
	ID_Maquinaria varchar(25), --Se creará una función o procedimiento almacenado para identificar el tipo de maquinaria
	Tiempo time not null
);

CREATE TABLE Lavadora_Producto(
	ID int not null primary key identity,
	ID_Lavadora varchar(25) not null foreign key references Lavadora(ID),
	ID_Producto varchar(25) not null foreign key references Producto(ID),
);

CREATE TABLE Secadora_Producto(
	ID int not null primary key identity,
	ID_Secadora varchar(25) not null foreign key references Secadora(ID),
	ID_Producto varchar(25) not null foreign key references Producto(ID),
);
