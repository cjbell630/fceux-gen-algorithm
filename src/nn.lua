--[[ BEGIN DEF Neuron ]]--

Neuron = {}
Neuron.__index = Neuron

-- from https://pastebin.com/ZZmSNaHX
function sigmoid(x)
    return 2 / (1 + math.exp(-4.9 * x)) - 1
end

function Neuron:new(inputs)
    local neuron = {}
    setmetatable(neuron, Neuron)
    neuron.inputs = inputs -- TODO inputs should be dict of index, weight
    return neuron
end

function Neuron:evaluate()
    local sum = 0
    for _, v in ipairs(self.inputs) do
        sum = sum + v:evaluate()
    end
    return sigmoid(self.weight * sum)
end

function Neuron:addInput(input, weight)
    self.inputs[input] = weight
end

--[[ END DEF Neuron ]]--

--[[ BEGIN DEF Input ]]--

Input = {}
Input.__index = Input

function Input:new(value)
    local input = {}
    setmetatable(input, Input)
    input.value = value
    return input
end

function Input:set(value)
    self.value = value
end

function Input:evaluate()
    return self.value
end

--[[ END DEF Input ]]--

--[[ BEGIN DEF Network ]]--


Network = {}
Network.__index = Network

function Network:new(genome)
    local network = {}
    setmetatable(input, Input)
    network.neurons = {}

    -- TODO populate inputs and outputs
    -- TODO populate outputs
    for i = -NUM_INPUTS - NUM_OUTPUTS, -NUM_INPUTS - 1, 1 do
        network.neurons[i] = Neuron:new({})
    end
    -- TODO populate inputs
    for i = -NUM_INPUTS, -1, 1 do
        network.neurons[i] = Input:new(0)
    end

    for innovNumber, gene in ipairs(genome.genes) do
        if gene.enabled then
            -- inputNode: if not input/output and not already in the network, add it
            if gene.inputNode >= 0 and network.neurons[gene.inputNode] == nil then
                network.neurons[gene.inputNode] = Neuron:new({})
            end

            --TODO output nodes are allowed here. input nodes shouldn't appear, but I should add a check anyway
            -- outputNode: if not already in the network, add it
            if network.neurons[gene.outputNode] == nil then
                network.neurons[gene.outputNode] = Neuron:new({})
            end
            network.neurons[gene.outputNode]:addInput(gene.inputNode, gene.weight)
        end
    end

    return network
end

function Network:evaluate()
    local outputs = {}
    -- iterate through outputs
    for i = -NUM_INPUTS - NUM_OUTPUTS, -NUM_INPUTS - 1, 1 do
        outputs[i] = self.neurons[i]:evaluate()
    end
    return outputs
end