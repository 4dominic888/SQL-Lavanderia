/***************************
	Tablas Complementarias
    ****************************/

--Agregar datos iniciales

insert into Genero values('Hombre'); --1
insert into Genero values('Mujer');  --2
insert into Genero values('Otros');  --3


insert into TipoEmpleado values
/*1*/ ('Recepcionista', 'Atiende a los clientes que piden el servicio de lavandería'),
/*2*/ ('Técnico', 'Encargado del mantenimiento de los equipos físicos, como lavadoras, secadoras y planchadoras'),
/*3*/ ('Administrador', 'Su función se basa en la adminsitración del negocio de la lavandería'),
/*4*/ ('Lavandero', 'Se encarga de la limpieza de la ropa de los clientes mediante el uso de los equipos físicos'),
/*5*/ ('Planchador', 'Encargado fundamentalmente en el planchado de la ropa, una vez que esté lavada y seca'),
/*6*/ ('Personal de limpieza', 'Limpia las áreas de trabajo y se encarga de mantener el local ordenado'),
/*7*/ ('Repartidor', 'Se encarga de transportar la ropa limpia del cliente al domicilio si se lo requiriera')


--En caso que se entrege una ropa que no cumpla con ningún valor en la base de datos, agregar un tipo de ropa más
insert into TipoRopa values
('Camiseta'), ('Pantalón'), ('Blusa'), ('Camisa'), ('Vestido'), ('Chaqueta'),
('Abrigo'), ('Traje'), ('Corbata'), ('Falda'), ('Short'), ('Ropa interior Hombre'),
('Ropa interior mujer'), ('Calcetines'), ('Pijama'), ('Bata'), ('Ropa deportiva'),
('Ropa de gimnasia'), ('Traje de baño'), ('Camisetas polo'), ('Sudadera'), ('Ropa formal'),
('Uniforme escolar'), ('Ropa de bebé'), ('Sábana'), ('Funda'), ('Chompa'),
('Toalla'), ('Mantel'), ('Alfombra'), ('Delantal'), ('Gorro')


--Los colores no deben ser del todo exactos, pero debe entrar en alguna de estas categorias
insert into ColorRopa values
('Blanco'), ('Negro'), ('Azul'), ('Gris'), ('Beige o Khaki'), ('Marrón'), ('Verde'),
('Rosado'), ('Amarillo'), ('Rojo'), ('Naranja'), ('MultiColor')


insert into MaterialRopa values
('Algodón'), ('Lino'), ('Poliéster'), ('Seda'), ('Denim'), ('Cuero'), ('Piel'), 
('Lana'), ('Cachemira'), ('Nailon'), ('Licra o Spandex'), ('Tercipelo'), ('Franela'),
('Mixto')


insert into TipoServicio values
('Estándar', 'El servicio por defecto que deja lavado, secado y planchado el conjunto de ropa', 10),
('En seco', 'Para prendas especiales que no necesiten de lavarse con agua', 3),
('Lavado y secado', 'Para el lavado y secado de la ropa, se excluye el planchado de la ropa', 8),
('Solo planchado', 'Para el planchado de prendas de ropa unicamente', 2),
('Eliminación de manchas', 'En caso la ropa tenga manchas difíciles de quitar', 15),
('Entrega a domicilio', 'El servicio de lavado estándar, con la diferencia de que la ropa será enviada a domicilio del cliente', 12)


insert into MetodoPago values
('Efectivo'), ('Tarjeta de crédito o debito'), ('Pago móvil'), ('Transferencia bancaria')


insert into EstadoMaquinaria values
('Encendido', 'Indica que la maquinaria está encendida y no esta siendo ocupada'),
('Apagado', 'Indica que la maquinaria está apagada'),
('En funcionamiento', 'Indica que la maquinaría esta siendo ocupada para una actividad'),
('Por arreglar', 'Indica que la maquinaria tiene fallas y es necesario llevarla a mantenimiento'),
('En mantenimiento', 'Indica que la maquinaria está siendo reparada')


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
	Funciones complementarias
    ****************************/

--Funcion que obtiene el entero de una ID que ya tiene el formato de ID de tipo varchar(25) unique
go
create or alter function ObtenerID (@idTexto nvarchar(25)) 
returns int as
begin
	return substring(@idTexto, 5, len(@idTexto))
end
go


--Funcion que en base al ID formateado, te genera el siguiente
go
create or alter function SiguienteID(@idTexto nvarchar(25), @prefijo char(3))
returns nvarchar(25) as
begin
	declare @numero int = dbo.ObtenerID(@idTexto) + 1;
	return concat(@prefijo, '-', @numero);
end
go


/*
Procedimiento almacenado que genera el formato de IDs de tablas designadas con el ID de tipo varchar(25) unique
el tercer parámetro regresa la ID como tal, se debe colocar una variable que tome ese valor seguido de OUTPUT
Ejemplo:

	declare @IDnueva nvarchar(25);
	exec CrearID 'CLI', 'Genero', @IDnueva output
	print @IDnueva
*/
go
create or alter procedure CrearID
	@prefijo char(3),
	@tabla nvarchar(255),
	@retorno nvarchar(25) output
as
begin
	begin try
		begin transaction

		--Si existe registros en la tabla, usar la ID del último registro, caso contrario, usar 1
		declare @sql nvarchar(200) = concat('if exists (select top(1) ID from ',@tabla,') ', 
												'set @r = (select top(1) ID from ', @tabla, ' order by ID desc) 
											else set @r = concat(''', @prefijo, ''', ''-'', ', '0)');	
		declare @idTabla nvarchar(25)
		exec sp_executesql @sql, N'@r nvarchar(25) output', @idTabla output
		set @retorno = dbo.SiguienteID(@idTabla, @prefijo);
		commit transaction
	end try
	begin catch
		print concat('Ha ocurrido un error en asignar el ID de la tabla ',@tabla )
		print ERROR_MESSAGE()
		print ERROR_LINE()
		rollback transaction
	end catch
end
go


/***************************
	Tablas Principales
    ****************************/
go
create or alter procedure RegistrarCliente
	@DNI char(8),
	@Apellido_Paterno nvarchar(100),
	@Apellido_Materno nvarchar(100),
	@Nombre nvarchar(100),
	@genero varchar(75) as
begin
	begin try
		begin transaction
		declare @idgenero int = (select ID from Genero where [Value] like trim(@genero))
		declare @idCliente varchar(25)
		exec CrearID 'CLI', 'Cliente', @idCliente output
		insert into Cliente values (@idCliente, @idgenero, @DNI, @Apellido_Paterno, @Apellido_Materno, @Nombre);
		commit transaction
	end try
	begin catch
		declare @posibleCausa varchar(150) = 'sea por otro motivo, lea el error para más detalles';
		select @posibleCausa = case ERROR_NUMBER()
			when 515 then 'el género esté mal escrito, debe ser hombre, mujer, otros u otro valor agregado de la tabla Genero'
			when 2627 then 'el DNI colocado ya exista'
			when 547 then 'el DNI tenga menos de 8 carácteres'
		end
		print ' '
		print concat('Es posible que ', @posibleCausa, '.');

		print ERROR_MESSAGE()
		rollback transaction
	end catch
end
go

select * from Cliente

exec RegistrarCliente '71821732', 'prueba', 'prueba', 'cc', 'hombre e'

