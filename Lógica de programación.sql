/***************************
	Tablas Complementarias
    ****************************/

--Agregar datos iniciales

insert into Genero values('Hombre'); --1
insert into Genero values('Mujer');  --2
insert into Genero values('Otros');  --3


insert into TipoEmpleado values
/*1*/ ('Recepcionista', 'Atiende a los clientes que piden el servicio de lavander�a'),
/*2*/ ('T�cnico', 'Encargado del mantenimiento de los equipos f�sicos, como lavadoras, secadoras y planchadoras'),
/*3*/ ('Administrador', 'Su funci�n se basa en la adminsitraci�n del negocio de la lavander�a'),
/*4*/ ('Lavandero', 'Se encarga de la limpieza de la ropa de los clientes mediante el uso de los equipos f�sicos'),
/*5*/ ('Planchador', 'Encargado fundamentalmente en el planchado de la ropa, una vez que est� lavada y seca'),
/*6*/ ('Personal de limpieza', 'Limpia las �reas de trabajo y se encarga de mantener el local ordenado'),
/*7*/ ('Repartidor', 'Se encarga de transportar la ropa limpia del cliente al domicilio si se lo requiriera')


--En caso que se entrege una ropa que no cumpla con ning�n valor en la base de datos, agregar un tipo de ropa m�s
insert into TipoRopa values
('Camiseta'), ('Pantal�n'), ('Blusa'), ('Camisa'), ('Vestido'), ('Chaqueta'),
('Abrigo'), ('Traje'), ('Corbata'), ('Falda'), ('Short'), ('Ropa interior Hombre'),
('Ropa interior mujer'), ('Calcetines'), ('Pijama'), ('Bata'), ('Ropa deportiva'),
('Ropa de gimnasia'), ('Traje de ba�o'), ('Camisetas polo'), ('Sudadera'), ('Ropa formal'),
('Uniforme escolar'), ('Ropa de beb�'), ('S�bana'), ('Funda'), ('Chompa'),
('Toalla'), ('Mantel'), ('Alfombra'), ('Delantal'), ('Gorro')


--Los colores no deben ser del todo exactos, pero debe entrar en alguna de estas categorias
insert into ColorRopa values
('Blanco'), ('Negro'), ('Azul'), ('Gris'), ('Beige o Khaki'), ('Marr�n'), ('Verde'),
('Rosado'), ('Amarillo'), ('Rojo'), ('Naranja'), ('MultiColor')


insert into MaterialRopa values
('Algod�n'), ('Lino'), ('Poli�ster'), ('Seda'), ('Denim'), ('Cuero'), ('Piel'), 
('Lana'), ('Cachemira'), ('Nailon'), ('Licra o Spandex'), ('Tercipelo'), ('Franela'),
('Mixto')


insert into TipoServicio values
('Est�ndar', 'El servicio por defecto que deja lavado, secado y planchado el conjunto de ropa', 10),
('En seco', 'Para prendas especiales que no necesiten de lavarse con agua', 3),
('Lavado y secado', 'Para el lavado y secado de la ropa, se excluye el planchado de la ropa', 8),
('Solo planchado', 'Para el planchado de prendas de ropa unicamente', 2),
('Eliminaci�n de manchas', 'En caso la ropa tenga manchas dif�ciles de quitar', 15),
('Entrega a domicilio', 'El servicio de lavado est�ndar, con la diferencia de que la ropa ser� enviada a domicilio del cliente', 12)


insert into MetodoPago values
('Efectivo'), ('Tarjeta de cr�dito o debito'), ('Pago m�vil'), ('Transferencia bancaria')


insert into EstadoMaquinaria values
('Encendido', 'Indica que la maquinaria est� encendida y no esta siendo ocupada'),
('Apagado', 'Indica que la maquinaria est� apagada'),
('En funcionamiento', 'Indica que la maquinar�a esta siendo ocupada para una actividad'),
('Por arreglar', 'Indica que la maquinaria tiene fallas y es necesario llevarla a mantenimiento'),
('En mantenimiento', 'Indica que la maquinaria est� siendo reparada')


insert into MarcaMaquinaria values
('Whirlpool'), ('Samsung'), ('LG'), ('Electrolux'), ('General Electric (GE)'), ('Maytag'), ('Kenmore'),
('Amana'), ('Bosch'), ('Frigidaire'), ('Panasonic'), ('Rowenta'), ('Black & Decker'), ('Shark')


insert into TipoProducto values
('Detergente'), ('Suavizante'), ('Blanqueador'), ('Quitamanchas'), ('Desinfectante'),
('Bolas de lana'), ('Piedras de vapor')


insert into MarcaProducto values
('Ariel'), ('Bolivar'), ('Home Care'), ('Skip'), ('Opal'), ('Tide'), ('Downy'), ('Woolite'), ('La oca'),
('Sapolio'), ('Vanish'), ('Woolzies'), ('Smart Sheep'), ('DryerMax'), ('Steam Stones')


/***************************
	Tablas Principales
    ****************************/

declare @webo int = (select ID from Genero where [Value] like trim('   o+tros  '))
print @webo

go
create or alter procedure RegistrarCliente
	@DNI char(8),
	@Apellido_Paterno nvarchar(100),
	@Apellido_Materno nvarchar(100),
	@Nombre nvarchar(100),
	@genero varchar(75) as
begin
	declare @idgenero int = (select ID from Genero where [Value] like trim(@genero))
	declare @idCliente varchar(25)
	/*
	if exists (select top(1) ID from Cliente)
		set @idCliente = 'CLI-1' --CLI-4578454125478541256987
	else begin
		
	end
	*/
	insert into Cliente values (@idgenero, )
end
go

--TODO: Crear una funci�n que te genere ID formateada piola
go
create or alter function CrearID(
	@prefijo char(3),
	@tabla nvarchar(255)
) 
returns varchar(25) as
begin
	declare @sql nvarchar(200) = 'set @r = (select top(1) ID from Genero)'
	declare @r int
	exec sp_executesql @sql, N'@r int output', @r output
	print @r
	return 'algo'
end
go