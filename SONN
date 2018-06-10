import numpy as np
import random
import time

L = 3 #count of layers;
Ni = [1, 1, 1] #count of i-th subnetwork
pi = [11, 10, 3] #threshold test for i-th subnetwork 7 5 3//10 5 2
M = 12 #count of input neurons

encode_letter = {'a': int('1101', 2), 'c': int('1110', 2), 'g': int('1000', 2), 't': int('0100', 2)}
#encode_letter = {'a': int('0001', 2), 'c': int('0010', 2), 'g': int('0100', 2), 't': int('1000', 2)}

def distance(lhd, rhd, len):
    sum = 0
    for i in range(len):
        if lhd[i] != rhd[i]:
            sum += 1
    return sum


def encode(pattern):
    res = []
    for letter in pattern:
        res.append(encode_letter[letter])
    return res


def choose_winner_category(input_pattern, layer):
    iterlist = []
    min = 10000000
    iter = -1
    for n in layer.children:
        sum = distance(encode(input_pattern), n.weight, M)
        #if sum == min:
            #iterlist.append(n)
        if sum < min:
            min = sum
            iterlist = []
            iterlist.append(n)
    return iterlist


def threshold_test(input_pattern, winner, test): 
    y = []
    for n in winner.children:
        sum = distance(encode(input_pattern), n.weight, M)
        y.append(sum)
    if len(winner.children)== 0:
        for n in winner.output:
            sum = 0
            for m in range(M):
                if input_pattern[m] != n.pattern[m]:
                    sum += 1
            y.append(sum)
        if len(y) == 0:
            return True
        return max(y) <= test
    return max(y) <= test


class Neuron(object):
    def __init__(self, weight, layer, children=None, parent=None, p_j = 1, output=None):
        self.weight = weight
        self.layer = layer
        self.parent = parent
        self.p_j = p_j
        self.output = []
        if output is not None:
            for out in output:
                self.add_output(out)
        self.children = []
        if children is not None:
            for child in children:
                self.add_child(child)
    def __repr__(self):
        return str(self.layer)
    def add_child(self, child):
        assert isinstance(child, Neuron)
        child.parent = self
        self.children.append(child)
    def add_output(self, child):
        self.output.append(child)


def recalculation_weights(node):
    up = node.parent
    for i in range(up.layer, 0, -1):
        sum = np.zeros(M)
        for j in up.children:
            sum += np.array(j.weight)
        up.weight = sum/len(up.children)
        up = up.parent


def eatingInputSeq(pattern, network):
    points = [network]
    flag = False
    for lay in range(L):
        if flag:
            flag = False
            break
        winners = []
        for point in points:
            onewinners = choose_winner_category(pattern.pattern, point)
            winners += onewinners
        points = []
        for win in winners:
            if (threshold_test(pattern.pattern, win, pi[lay])):
                points.append(win)
                if (lay == L - 1):
                    sum = np.zeros(M)
                    win.add_output(pattern)
                    win.p_j += 1
                    for i in win.output:
                        sum += np.array(encode(i.pattern))
                    win.weight = 1 / win.p_j * sum
                    recalculation_weights(win)

            else:
                l = win.layer
                down = win.parent

                for i in range(l, L + 1):
                    tmp = Neuron(encode(pattern.pattern ), i)
                    down.add_child(tmp)
                    down = tmp
                down.add_output(pattern)

                recalculation_weights(win)

                flag = True
                break



def circle(test_data, network):
    for test_pattern in test_data:
        eatingInputSeq(test_pattern, network)


motifs = []

def print_network(network):
    if network.layer == L:
        if len(network.output) >= 3:
            motifs.append(network.output)
            #print(network.output)
        #else:
            #network.output = []
            #recalculation_weights(network)
    else:
        for ch in network.children:
            print_network(ch)



class Pattern(object):
    def __init__(self, num, pattern):
        self.num = num
        self.pattern = pattern
    def __repr__(self):
        return str(self.pattern + ' ' + str(self.num))


def Network(start_pattern):
    return Neuron([],0, [Neuron(encode(start_pattern.pattern),1,[Neuron(encode(start_pattern.pattern),2,[Neuron(encode(start_pattern.pattern),3,output=[start_pattern])])])])


def sliceup(seq, num):
    return [Pattern(num, seq[i:i+M]) for i in range(0, len(seq)- M + 1)]


alphabet = ['a', 'c', 'g', 't']

def gen_motif(len_motif):
    motif = ''.join(np.random.choice(alphabet, len_motif))
    motifs.append(motif)
    return motif

def make_seq(len_seq, motif, mismatch):
    #switch_poses = np.random.choice([i for i in range(0, len(motif))], mismatch_count)
    lmotif = list(motif)
    rand_pos = np.random.choice(mismatch, np.random.randint(0, 4))
    for letter in rand_pos:
        m = alphabet[:]
        m.remove(lmotif[letter])
        lmotif[letter] = ''.join(np.random.choice(m, 1))
    lmotif = ''.join(lmotif)
    seq_no_motif = ''.join(np.random.choice(alphabet, len_seq))
    pos = np.random.randint(0, len(seq_no_motif) - len(lmotif))
    seq = seq_no_motif[:pos] + lmotif + seq_no_motif[pos:]
    return seq

