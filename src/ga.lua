-- starts at -1 bc first innovation will be 0. starting at 0 would require storing the value before incrementing which is inefficient
currInnovations = -1

function innovate()
    currInnovations = currInnovations + 1
    return currInnovations
end

--[[ BEGIN DEF Gene ]]--

Gene = {}
Gene.__index = Gene

function Gene:new(inputNode, outputNode, weight, innovNumber)
    local gene = {}
    setmetatable(gene, Gene)
    gene.inputNode = inputNode
    gene.outputNode = outputNode
    gene.weight = weight
    gene.innovNumber = innovNumber
    gene.enabled = true
    return gene
end

function Gene:toggleEnabled()
    self.enabled = not self.enabled
end

function Gene:copy()
    return Gene:new(self.inputNode, self.outputNode, self.weight, self.innovNumber)
end

--[[ END DEF Gene ]]--

--[[ BEGIN DEF Genome ]]--

Genome = {}
Genome.__index = Genome

function Genome:new()
    local genome = {}
    setmetatable(genome, Genome)
    genome.genes = {}
    genome.fitness = 0
    genome.numHiddenNodes = 0
    return genome
end

-- crossover parent1 and parent2
function Genome:new(parent1, parent2)
    local genome = {}
    setmetatable(genome, Genome)
    genome.genes = {}
    local domParent = nil
    local otherParent = nil

    if (parent1.fitness >= parent2.fitness) then
        domParent = parent1
        otherParent = parent2
    else
        domParent = parent2
        otherParent = parent1
    end

    for innovNumber, gene in ipairs(domParent.genes) do
        -- if both parents have the gene, and 50% chance, then inherit the gene from parent2
        -- if only parent1 has the gene, then inherit the gene from parent1
        genome.genes[innovNumber] = (otherParent.genes[innovNumber] ~= nil and math.random(2) == 1) and
                otherParent.genes[innovNumber]:copy() or gene:copy()
    end

    genome.numHiddenNodes = domParent.numHiddenNodes -- TODO should work
    genome.fitness = 0
    return genome
end

function Genome:addGene(gene)
    self.genes[gene.innovNumber] = gene
end

function Genome:connectionExists(inputNode, outputNode)
    for _, v in ipairs(self.genes) do
        if v.inputNode == inputNode and v.outputNode == outputNode then
            return true
        end
    end
    return false
end

-- create a new connection between two unconnected nodes
function Genome:newConnectionMutation()
    -- declared here for scope
    local inputNode = 0
    local outputNode = 0
    -- find two unconnected nodes TODO could be more efficient
    repeat
        inputNode = math.random(-NUM_INPUTS, self.numHiddenNodes)
        outputNode = math.random(-NUM_OUTPUTS, self.numHiddenNodes)
        if outputNode < 0 then -- if output node is an output, then shift it to the correct position
            outputNode = outputNode - NUM_INPUTS
        end
    until not self:connectionExists(inputNode, outputNode)

    self:addGene(Gene:new(inputNode, outputNode, 0, innovate()))
end

-- insert node between two already connected nodes, disabling the old connection and creating two new ones
function Genome:newNodeMutation()
    -- TODO should this only look for enabled genes?
    local randomGene = self.genes[math.random(1, #self.genes)]
    randomGene.enabled = false

    self.numHiddenNodes = self.numHiddenNodes + 1 -- add new hidden node

    self:addGene(Gene:new(randomGene.inputNode, self.numNodes, randomGene.weight, innovate()))
    self:addGene(Gene:new(self.numNodes, randomGene.outputNode, 1, innovate()))
end

function Genome:weightChangeMutation()
    local randomGene = self.genes[math.random(1, #self.genes)]
    -- TODO instead of -1 and 1, this should be based on mutation rate
    randomGene.weight = randomGene.weight + math.random(-1, 1)
end

--[[ END DEF Genome ]]--