import SONN
import json
import random
import time
import numpy as np
import math

MAX_INT = 10000

grlist = []
observesion = []
seqs = []
path = "../tests/1.json" # задайте свой путь

def Round(nodes, network):
    patterns = []
    for node in nodes:
        patterns += SONN.sliceup(seqs[node], node)

    if network == []:
        network = SONN.Network(patterns[0])
        patterns.pop()

    random.shuffle(patterns)

    for pattern in patterns:
        SONN.eatingInputSeq(pattern, network)

    SONN.print_network(network)
    return network


def transormGraphView(graph, n):
    matrixGraph = []
    for node in graph:
        matrixGraph.append([1 if i in node else MAX_INT for i in range(0, n)])
    return matrixGraph


def reachability_matrix(graph, n):
    reach_graph = np.copy(graph)
    for k in range(0,n): # building the reachability matrix
        for i in range(0, n):
            for j in range(0, n):
                #reach_graph[i,j] = reach_graph[i,j] or (reach_graph[i, k] and reach_graph[k, j])
                reach_graph[i, j] = min(reach_graph[i, j], reach_graph[i, k]+reach_graph[k, j])
    return reach_graph


def isFromTo(_from, _to, reachM, n):
    volume = set([i.num for i in _from])
    for iter in _from:
        ex = {i if reachM[iter.num, i] != MAX_INT else -1 for i in range(0, n)}
        ex.discard(-1)
        volume.update(ex)
    return volume.issuperset(set(_to))


def distance_between_set_and_observableset(just_set, observableset, dist_matrix):
    sum = 0
    for onode in observableset:
        sum += min([dist_matrix[jnode,onode] for jnode in just_set])
    return sum/len(observableset)


def calculate_probabilities(seqs):
    allseqs = ''.join(seqs)
    norm = len(allseqs)
    letters = {'a': 0, 'c': 0, 'g': 0, 't': 0}
    for letter in allseqs:
        letters[letter] += 1
    for letter in letters.keys():
        letters[letter] = letters[letter] / norm
    return letters, norm

def get_p_value(motif_set, num_of_letters, len_mot, b):
    X = num_of_letters - len_mot + 1
    w = 1
    for i in range(0, len_mot):
        letters = {j[i] for j in motif_set}
        w *= len(letters)
    sum_of_P_b_k = sum([pow(1/4, len_mot) for i in range(0, w)])
    return 1 - np.math.fsum(
        [math.factorial(X) / math.factorial(X - j) / math.factorial(j) * pow(sum_of_P_b_k, j) * pow((1 - sum_of_P_b_k), X - j) for j in
         range(0, b)])


def calculate_fi(motif_set, seqs, observableset, dist_matrix):
    delta = distance_between_set_and_observableset([it.num for it in motif_set], observableset, dist_matrix)
    probabilities, norm = calculate_probabilities(seqs)
    sigma = get_p_value([it.pattern for it in motif_set], norm, SONN.M, len(motif_set))
    alpha = 1-10e-15
    return alpha*sigma + (1 - alpha)*delta


tres = 0
clocks = 0


N_L = 40

with open("C:/Users/Gleb/PycharmProjects/GibbsSampling/tests/"+str(13)+".json", mode='r', encoding='utf-8') as f: # путь из входных данных.
    r = json.load(f)
    net_ = list()
    hidden_ = list()
    express_ = list()
    input_seq_n_ = list()
    for i in r['net'].lstrip('[').rstrip(']').split('], ['):
        firststep = i.split(',')
        s = []
        for j in firststep:
            if len(j) > 0:
                s.append(int(j))
        net_.append(s)
    for i in r['hidden'].lstrip('[').rstrip(']').split(','):
        hidden_.append(int(i))
    for i in r['express'].lstrip('[').rstrip(']').split(','):
        express_.append(int(i))

    for i in r['input_seq_n'].lstrip('[').rstrip(']').split(','):
        input_seq_n_.append(i.lstrip(' ').strip("'"))

    grlist = net_
    observesion = express_
    seqs = input_seq_n_
    aim = r['motif']
    print(aim)

SONN.motifs = []
nodes = observesion
used = []
net = []
start_time = time.time()
rm = reachability_matrix(transormGraphView(grlist, N_L), N_L)

uss = []
for it in range(0, N_L):
    ex = {i if rm[it, i] != MAX_INT or i == it else -1 for i in range(0, N_L)}
    ex.discard(-1)
    if len(ex.intersection(observesion)) != 0:
        uss.append(it)

np.random.shuffle(uss)
print(uss)
net = Round(uss, net)
testfeed = {}

motifs = []
for iter in SONN.motifs:
        if isFromTo(iter, observesion, rm, N_L):
            motifs.append(iter)


end_set = []
for item in motifs:
    tmp = [i for i in item]
    where = {i for i in range(0, N_L)}.difference({i.num for i in item})
    for i_seq in where:
        for i in range(0, len(seqs[i_seq]) - SONN.M + 1):
            cnt = 0
            for iter in item:
                if SONN.distance(seqs[i_seq][i:i + SONN.M], iter.pattern, SONN.M) > 3:
                    break
                cnt += 1
            if cnt == len(item):
                tmp.append(SONN.Pattern(i_seq, seqs[i_seq][i:i + SONN.M]))
                break
    end_set.append(tmp)
res = []
tt = time.time() - start_time
testfeed["time"] = str(tt)
print("time:", tt)
clocks += tt
testfeed["motifs"] = str(end_set)
ff = False
minvalue = 1
for i in end_set:
    tmp = calculate_fi(i,seqs, observesion, rm)
    print(tmp,":", i)
    if tmp < minvalue:
        minvalue = tmp
        estimating = [i, tmp]

print(estimating)
print('-----------------------------------------')



