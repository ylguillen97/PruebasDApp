const Dron_Company = artifacts.require("Dron_Company");
const expect = require('chai').expect;

contract ('Dron_Company', accounts => {
    [cuenta1, cuenta2, cuenta3] = accounts ; 
    console.log("Cuenta 1: " + cuenta1);
    console.log("Cuenta 2: " + cuenta2);
    console.log("Cuenta 3: " + cuenta3);
    let companyInstance;
    
    beforeEach (async() => {
        companyInstance  = await Dron_Company.new();
    });


context ('Constructor', async()=> {
    it ('Identifiers', async()=> {
        const iddron = await companyInstance.id_dron();
        const idplot = await companyInstance.id_plot();
        expect (iddron.toNumber()).to.equal(0);
        expect (idplot.toNumber()).to.equal(0);

    });
});

context ('Registro de drones', async()=> 
{
    it ('Registrar Dron con altura máxima menor que la altura mínima', async()=> {
        try
        {
            const result = await companyInstance.registraDron(10, 100, 2, {from:cuenta1});

        }
        catch (error)
        {
            expect (error.reason).to.equal();
        }
    });

    it ('Registrar Dron con coste cero', async()=> {
        try
        {
            await companyInstance.registraDron(100, 10, 0, {from:cuenta1});
        }
        catch (error)
        {
            expect (error)
        }
    });

    it ('Registrar Dron con altura mínima cero', async()=> {
        try
        {
            await companyInstance.registraDron(100, 0, 2, {from:cuenta1});
        }
        catch (error)
        {
            expect (error)
        }
    });  
    
    it ('Registro correcto de un dron', async() => {
        const result = await companyInstance.registraDron(100, 10, 2, {from:cuenta1});
        expect(result.receipt.status).to.equal(true)
    });

});

context ('Registro de parcelas', async()=> {
    it ('Registrar Parcela con altura máxima menor que la altura mínima', async()=> {
        try
        {
            await companyInstance.registraPlot(10, 100, "Pesticida A", {from:cuenta2});
        }
        catch (error)
        {
            expect (error)
        }
    });

    it ('Registrar Parcela con altura mínima cero', async()=> {
        try
        {
            await companyInstance.registraPlot(100, 0, "Pesticida A", {from:cuenta2});
        }
        catch (error)
        {
            expect (error)
        }
    });

    it ('Registrar Parcela con pesticida inválido', async()=> {
        try
        {
            await companyInstance.registraPlot(100, 10, "PesticidaA", {from:cuenta2});
        }
        catch (error)
        {
            expect (error)
        }
    });
    it ('Registro correcto de una parcela', async() => {
        const result = await companyInstance.registraPlot(100, 10, "Pesticida A", {from: cuenta2});
        expect(result.receipt.status).to.equal(true);
    });
});

context ('Compra de UNTKs', async()=> {
    it ('Compra de tokens sin saldo', async()=> {
        try{
            const result = await companyInstance.buyTokens(10, {from: cuenta2});
            console.log(result)
        }
        catch(error)
        {
            expect (error)
        }
    });

    it ('Compra de tokens correcta', async()=> {
        const result = await companyInstance.buyTokens(10, {from: cuenta2 , value: 25000});
        expect(result.receipt.status).to.equal(true);
    });
    it ('Balance ', async()=> {
        const result = await companyInstance.getBalanceOf(cuenta2);
       console.log (result.toString());
    });

});

context ('Contrata un Dron', async()=> {
    it ('Los identificadores de la parcela y el dron son cero', async()=> {
        try {
            await companyInstance.ContrataDron(0, 0, {from:cuenta2, value: 25000});
        } catch (error) {
            expect(error)
        }

    });

    it ('Contrato de un dron por una direccion distinta a la del owner de la parcela', async()=> {
        try {
            await companyInstance.ContrataDron(1, 1, {from: cuenta1});
        } catch (error) {
            expect(error);
        }

    });

    it ('Contrato de un dron con altura máxima mayor a la permitida en la parcela', async()=> {
        await companyInstance.registraDron(300, 10, 2, {from: cuenta1});
        try {
            await companyInstance.ContrataDron(2, 1, {from: cuenta2});
        } catch (error) {
            expect(error);
        }

    });

    it ('Contrato de un dron con altura mínima menor a la permitida en la parcela', async()=> {
        await companyInstance.registraDron(100, 5, 2, {from: cuenta1});
        try {
            await companyInstance.ContrataDron(3, 1, {from: cuenta2});
        } catch (error) {
            expect(error);

        }

    });

});

context ('Acepta Trabajo', async()=> {
    it ('Aceptar trabajo con identificador de parcela 0', async()=> {
       
        try {
            await companyInstance.aceptaTrabajo(1, 0, {from: cuenta1});
        } catch (error) {
            expect(error);

        }
    });

});

});