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
('Toalla'), ('Mantel'), ('Alfombra'), ('Delantal'), ('Gorro'), ('Jean')

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
		if(len(@prefijo) = 3) begin
			--Si existe registros en la tabla, usar la ID del último registro, caso contrario, usar 1
			declare @sql nvarchar(200) = concat('if exists (select top(1) ID from ',@tabla,') ', 
													'set @r = (select top(1) ID from ', @tabla, ' order by ID desc) 
												else set @r = concat(''', @prefijo, ''', ''-'', ', '0)');	
			declare @idTabla nvarchar(25)
			exec sp_executesql @sql, N'@r nvarchar(25) output', @idTabla output
			set @retorno = dbo.SiguienteID(@idTabla, @prefijo);
			commit transaction
		end
		else begin
			print('El prefijo no tiene 3 carácteres, creación de ID fallida')
			rollback transaction
		end
	end try
	begin catch
		print concat('Ha ocurrido un error en asignar el ID de la tabla ',@tabla )
		print ERROR_MESSAGE()
		print ERROR_LINE()
		rollback transaction
	end catch
end
go


/*
Procedimiento almacenado que retorna una ID de aquellas tablas que tengan el formato de int identity.

No retorna nada si no logra encontrar el valor, esto se validará en las funciones que implementen este
procedimiento almacenado.
*/
go
create or alter procedure ObtenerIDTablasComplementarias
	@tabla nvarchar(255),
	@value varchar(200),
	@ID int output
as
begin
	begin transaction
		begin try
			declare @sql nvarchar(200) = concat('set @retorno = (select top(1) ID from ',@tabla,
																' where [Value] like trim(''', @value, '''))');

			exec sp_executesql @sql, N'@retorno int output', @ID output
			commit transaction
		end try
		begin catch
			print concat('Ha ocurrido un error en obtener el ID de la tabla ',@tabla )
			print ERROR_MESSAGE()
			print ERROR_LINE()
			rollback transaction
		end catch
end
go


--Obtener ID mediante DNI para las tablas que posean de atributo DNI
--TODO: hacer lo mismo pero que se busque mediante nombre y apellido
go
create or alter function ObtenerIDClientePorDNI(@DNI char(8)) returns varchar(25) as
begin
	return (select top(1) ID from Cliente where DNI = @DNI);
end
go

go
create or alter function ObtenerIDEmpleadoPorDNI(@DNI char(8)) returns varchar(25) as
begin
	return (select top(1)ID from Empleado where DNI = @DNI);
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
		declare @idgenero int;

		--obtener id de forma dinámica para genero
		exec ObtenerIDTablasComplementarias 'Genero', @genero, @idgenero output
		declare @idCliente varchar(25)

		--obtener id de forma dinámica para la tabla correspondiente
		exec CrearID 'CLI', 'Cliente', @idCliente output
		insert into Cliente values (@idCliente, @idgenero, @DNI, @Apellido_Paterno, @Apellido_Materno, @Nombre);
		commit transaction
	end try
	begin catch
		declare @posibleCausa varchar(150) = 'sea por otro motivo, lea el error para más detalles';
		select @posibleCausa = case ERROR_NUMBER()
			when 515 then 'el género esté mal escrito, debe ser hombre, mujer u otro valor agregado de la tabla Genero'
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

--Datos de prueba
exec RegistrarCliente '78549632', 'Dominguez', 'Cabrera', 'Carlos Paolo', 'Hombre'
exec RegistrarCliente '12345678', 'López', 'Ramírez', 'Ana María', 'mujer'
exec RegistrarCliente '87654321', 'García', 'Mendoza', 'Luis Alberto', 'hombre'
exec RegistrarCliente '23456789', 'Torres', 'Pérez', 'María José', 'mujer'
exec RegistrarCliente '98765432', 'Rodríguez', 'Chávez', 'Ricardo', 'hombre'
exec RegistrarCliente '34567890', 'Gómez', 'Flores', 'Luz Elena', 'mujer'
exec RegistrarCliente '76543210', 'Paredes', 'Gutiérrez', 'Juan Carlos', 'hombre'
exec RegistrarCliente '45678901', 'Vargas', 'Jiménez', 'Isabel', 'mujer'



go
create or alter procedure RegistrarEmpleado
	@DNI char(8),
	@Apellido_Paterno nvarchar(100),
	@Apellido_Materno nvarchar(100),
	@Nombre nvarchar(100),
	@genero varchar(75),
	@tipoEmpleado varchar(100),
	@sueldo money as
begin
	begin try
		begin transaction
		declare @idgenero int,
				@idtipoempleado int,
				@idEmpleado varchar(25)

		--obtener id de forma dinámica para genero
		exec ObtenerIDTablasComplementarias 'Genero', @genero, @idgenero output

		--obtener id de forma dinámica para tipoEmpleado
		exec ObtenerIDTablasComplementarias 'TipoEmpleado', @tipoEmpleado, @idtipoempleado output

		--obtener id de forma dinámica para la tabla correspondiente
		exec CrearID 'EMP', 'Empleado', @idEmpleado output
		insert into Empleado values (@idEmpleado, @idgenero, @DNI, @Apellido_Paterno, @Apellido_Materno, @Nombre, @idtipoempleado, @sueldo);
		commit transaction
	end try
	begin catch
		declare @posibleCausa varchar(150) = 'sea por otro motivo, lea el error para más detalles';
		select @posibleCausa = case ERROR_NUMBER()
			when 515 then 'el género o el tipo empleado esté mal escrito, debe ser algún valor válido de la tabla correspondiente'
			when 2627 then 'el DNI colocado ya exista'
			when 547 then 'el DNI tenga menos de 8 carácteres o el sueldo sea menor a 800'
		end
		print ' '
		print concat('Es posible que ', @posibleCausa, '.');

		print ERROR_MESSAGE()
		rollback transaction
	end catch
end
go

--Datos de prueba
exec RegistrarEmpleado '85632145', 'Gonzales', 'Diaz', 'Gerardo', 'hombre', 'Lavandero', 950.00
exec RegistrarEmpleado '12345678', 'Lopez', 'Gomez', 'Maria', 'mujer', 'Recepcionista', 820.50
exec RegistrarEmpleado '98765432', 'Martinez', 'Perez', 'Carlos Alberto', 'hombre', 'Técnico', 900.25
exec RegistrarEmpleado '45678901', 'Garcia', 'Rodriguez', 'Ana Isabel', 'mujer', 'Administrador', 1050.75
exec RegistrarEmpleado '23456789', 'Fernandez', 'Hernandez', 'Juan Manuel', 'hombre', 'Planchador', 880.60
exec RegistrarEmpleado '76543210', 'Gonzalez', 'Silva', 'Laura Carolina', 'mujer', 'Personal de limpieza', 810.90
exec RegistrarEmpleado '54321098', 'Torres', 'Lopez', 'Roberto', 'hombre', 'Repartidor', 830.40
exec RegistrarEmpleado '87654321', 'Perez', 'Mendoza', 'Luis Antonio', 'hombre', 'Lavandero', 920.30



go
create or alter procedure RegistrarRopaPorDNI
@TipoRopa varchar(100),
@Color varchar(100),
@Material varchar(100),
@DNI char(8),
@Peso float,
@Detalle text = null as
begin
	begin try
		begin transaction
		declare @idRopa varchar(25),
				@idTipoRopa int,
				@idColor int,
				@idMaterial int,
				@idCliente varchar(25)

		exec CrearID 'ROP', 'Ropa', @idRopa output
		exec ObtenerIDTablasComplementarias 'TipoRopa', @TipoRopa, @idTipoRopa output
		exec ObtenerIDTablasComplementarias 'ColorRopa', @Color, @idColor output
		exec ObtenerIDTablasComplementarias 'MaterialRopa', @Material, @idMaterial output
		set @idCliente = dbo.ObtenerIDClientePorDNI(@DNI);

		insert into Ropa values(@idRopa, @idTipoRopa, @idColor, @idMaterial, @idCliente, @Peso, @Detalle)

		commit transaction
	end try
	begin catch
		declare @posibleCausa varchar(150) = 'sea por otro motivo, lea el error para más detalles';
		select @posibleCausa = case ERROR_NUMBER()
			when 515 then 'algún dato esté mal escrito, debe ser algún valor válido de la tabla correspondiente'
			when 547 then 'algún dato tenga un formato no adecuado, revise siguiente mensaje para más detalle'
		end
		print ' '
		print concat('Es posible que ', @posibleCausa, '.');

		print ERROR_MESSAGE()
		rollback transaction
	end catch
end
go

exec RegistrarRopaPorDNI 'camiseta', 'Azul', 'seda', '98765432', 100, 'Lavar por separado'
exec RegistrarRopaPorDNI 'jean', 'Azul', 'denim', '98765432', 950

select * from Ropa

--TODO: registrar maquinarias