DROP TABLE IF EXISTS Cliente;
GO

CREATE TABLE Cliente(
nombreEmpresa VARCHAR(100),
nombreCliente VARCHAR(100),
tipoCliente VARCHAR(30),
Linea VARCHAR(20),
NroCelular VARCHAR(9),
Monto MONEY,
fechaContratacion DATE,
tipoServicio VARCHAR(30)
)
GO