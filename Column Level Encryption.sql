--Primero, creamos una Database Master Key, la cual protegerá el certificado que crearemos en el siguiente paso.
USE BitacoraDBA;
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Bitac@2020';

--Segundo, creamos un certificado, el cual protegerá la clave simétrica que crearemos en el paso 3.

USE BitacoraDBA;
GO
CREATE CERTIFICATE Certificado_prueba WITH SUBJECT = 'Encripta una columna';
GO

--Tercero, creamos una clave simétrica usando el certificado creado en el paso anterior.

CREATE SYMMETRIC KEY LlaveSimetrica_Prueba 
WITH ALGORITHM = AES_256 ENCRYPTION BY CERTIFICATE Certificado_prueba;

--Cuarto, añadimos una nueva columna a la tabla, que almacenará la data ya encriptada. Esta nueva columna debe ser de tipo VARBINARY.

ALTER TABLE dbo.clientes ADD nrotarjeta_encriptado varbinary(MAX)

--Por último, encriptamos la data usando la clave simétrica y el comando ENCRYPTBYKEY:

OPEN SYMMETRIC KEY LlaveSimetrica_prueba 
DECRYPTION BY CERTIFICATE Certificate_prueba;

--Almacenamos la data encriptada en la nueva columna 
UPDATE dbo.clientes
SET nrotarjeta_encriptado = ENCRYPTBYKEY(Key_GUID('LlaveSimetrica_prueba'), nrotarjeta)
FROM dbo.clientes;
GO

--Cerramos la llave simétrica después de haberla usado
CLOSE SYMMETRIC KEY LlaveSimetrica_prueba;
GO